// Tiny Chrome DevTools driver for Flutter web screenshots.
// Usage: node cdp.mjs plan.json
// plan: { base, width, height, out, steps: [ {go:"?as=sales#/sales/home", wait:4000},
//          {shot:"name"}, {click:[x,y]}, {type:"text"}, {key:"Enter"}, {wait:ms}, {scroll:[x,y,dy]},
//          {size:[w,h]} ] }
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';

const plan = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
const base = plan.base ?? 'http://localhost:8765/';
const out = plan.out ?? path.join(path.dirname(process.argv[2]), 'shots');
fs.mkdirSync(out, { recursive: true });
const port = 9333 + Math.floor(Math.random() * 500);
const profile = fs.mkdtempSync(path.join(os.tmpdir(), 'o2ocdp-'));
const chrome = spawn('C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe', [
  '--headless=new', '--disable-gpu', '--hide-scrollbars', '--no-first-run',
  '--no-default-browser-check', `--remote-debugging-port=${port}`, `--user-data-dir=${profile}`,
  '--window-size=1400,1000', 'about:blank',
], { stdio: 'ignore' });

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
async function getJson(url, method = 'GET') {
  for (let i = 0; i < 50; i++) {
    try { const r = await fetch(url, { method }); return await r.json(); } catch { await sleep(200); }
  }
  throw new Error('chrome did not start');
}
const targets = await getJson(`http://127.0.0.1:${port}/json/list`);
const page = targets.find((t) => t.type === 'page');
const ws = new WebSocket(page.webSocketDebuggerUrl);
await new Promise((r) => ws.addEventListener('open', r, { once: true }));
let id = 0;
const pending = new Map();
const logs = [];
ws.addEventListener('message', (ev) => {
  const msg = JSON.parse(ev.data);
  if (msg.id && pending.has(msg.id)) { pending.get(msg.id)(msg); pending.delete(msg.id); return; }
  if (msg.method === 'Runtime.consoleAPICalled') {
    const text = msg.params.args.map((a) => a.value ?? a.description ?? '').join(' ');
    logs.push(`[${msg.params.type}] ${text}`);
  } else if (msg.method === 'Runtime.exceptionThrown') {
    const d = msg.params.exceptionDetails;
    logs.push(`[exception] ${d.exception?.description ?? d.text}`);
  } else if (msg.method === 'Log.entryAdded') {
    logs.push(`[log ${msg.params.entry.level}] ${msg.params.entry.text}`);
  }
});
const send = (method, params = {}) => new Promise((resolve) => {
  const mid = ++id; pending.set(mid, resolve); ws.send(JSON.stringify({ id: mid, method, params }));
});

await send('Runtime.enable');
await send('Log.enable');
await send('Page.enable');
let w = plan.width ?? 390, h = plan.height ?? 844;
const metrics = () => send('Emulation.setDeviceMetricsOverride', { width: w, height: h, deviceScaleFactor: plan.scale ?? 1, mobile: false });
await metrics();

for (const s of plan.steps) {
  if (s.size) { [w, h] = s.size; await metrics(); await sleep(600); }
  if (s.go !== undefined) {
    logs.push(`--- go ${s.go}`);
    await send('Page.navigate', { url: 'about:blank' });
    await sleep(150);
    await send('Page.navigate', { url: base + s.go });
    await sleep(s.wait ?? 4500);
  } else if (s.click) {
    const [x, y] = s.click;
    for (const type of ['mouseMoved', 'mousePressed', 'mouseReleased']) {
      await send('Input.dispatchMouseEvent', { type, x, y, button: 'left', clickCount: 1, pointerType: 'mouse' });
      await sleep(30);
    }
    await sleep(s.wait ?? 900);
  } else if (s.type !== undefined) {
    await send('Input.insertText', { text: s.type });
    await sleep(s.wait ?? 400);
  } else if (s.key) {
    const code = { Enter: 13, Tab: 9, Backspace: 8, Escape: 27 }[s.key];
    await send('Input.dispatchKeyEvent', { type: 'keyDown', key: s.key, code: s.key, windowsVirtualKeyCode: code });
    await send('Input.dispatchKeyEvent', { type: 'keyUp', key: s.key, code: s.key, windowsVirtualKeyCode: code });
    await sleep(s.wait ?? 600);
  } else if (s.scroll) {
    const [x, y, dy] = s.scroll;
    await send('Input.dispatchMouseEvent', { type: 'mouseWheel', x, y, deltaX: 0, deltaY: dy });
    await sleep(s.wait ?? 900);
  } else if (s.wait) {
    await sleep(s.wait);
  }
  if (s.shot) {
    const r = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync(path.join(out, `${s.shot}.png`), Buffer.from(r.result.data, 'base64'));
    console.log(`shot ${s.shot}`);
  }
}
fs.writeFileSync(path.join(out, 'console.log'), logs.join('\n'));
const important = logs.filter((l) => /exception|error|Error|══|overflow|Another exception/.test(l));
console.log(important.slice(0, 60).join('\n'));
ws.close();
chrome.kill();
process.exit(0);
