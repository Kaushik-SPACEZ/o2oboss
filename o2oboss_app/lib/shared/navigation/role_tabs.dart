import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/models/models.dart';

class RoleTab {
  const RoleTab(this.path, this.icon, this.activeIcon, this.label);

  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String Function(AppLocalizations t) label;
}

/// Five bottom tabs per role, as the spec lists them (section 53.2). The
/// customer's Products tab sits in the middle by client request (2026-09-13);
/// their Orders moved into Profile to make room. Everything else lives
/// inside these areas.
List<RoleTab> tabsFor(UserRole role) => switch (role) {
      UserRole.sales => [
          RoleTab('/sales/home', Icons.home_outlined, Icons.home, (t) => t.navHome),
          RoleTab('/sales/enquiries', Icons.list_alt_outlined, Icons.list_alt, (t) => t.navEnquiries),
          RoleTab('/sales/refer', Icons.add_circle_outline, Icons.add_circle, (t) => t.navRefer),
          RoleTab('/sales/earnings', Icons.account_balance_wallet_outlined,
              Icons.account_balance_wallet, (t) => t.navEarnings),
          RoleTab('/sales/profile', Icons.person_outline, Icons.person, (t) => t.navProfile),
        ],
      UserRole.backOffice => [
          RoleTab('/bo/home', Icons.home_outlined, Icons.home, (t) => t.navHome),
          RoleTab('/bo/enquiries', Icons.list_alt_outlined, Icons.list_alt, (t) => t.navEnquiries),
          RoleTab('/bo/followups', Icons.phone_callback_outlined, Icons.phone_callback,
              (t) => t.navFollowUps),
          RoleTab('/bo/tasks', Icons.task_alt_outlined, Icons.task_alt, (t) => t.navTasks),
          RoleTab('/bo/more', Icons.grid_view_outlined, Icons.grid_view, (t) => t.navMore),
        ],
      UserRole.vendor => [
          RoleTab('/vendor/home', Icons.home_outlined, Icons.home, (t) => t.navHome),
          RoleTab('/vendor/referrals', Icons.inbox_outlined, Icons.inbox, (t) => t.navReferrals),
          RoleTab('/vendor/chat', Icons.chat_bubble_outline, Icons.chat_bubble, (t) => t.navChat),
          RoleTab('/vendor/quotations', Icons.request_quote_outlined, Icons.request_quote,
              (t) => t.navQuotations),
          RoleTab('/vendor/more', Icons.grid_view_outlined, Icons.grid_view, (t) => t.navMore),
        ],
      UserRole.customer => [
          RoleTab('/customer/home', Icons.home_outlined, Icons.home, (t) => t.navHome),
          RoleTab('/customer/requirement', Icons.assignment_outlined, Icons.assignment,
              (t) => t.navRequirement),
          RoleTab('/customer/products', Icons.storefront_outlined, Icons.storefront,
              (t) => t.navProducts),
          RoleTab('/customer/quotations', Icons.request_quote_outlined, Icons.request_quote,
              (t) => t.navQuotations),
          RoleTab('/customer/profile', Icons.person_outline, Icons.person, (t) => t.navProfile),
        ],
      UserRole.franchise => [
          RoleTab('/franchise/home', Icons.home_outlined, Icons.home, (t) => t.navHome),
          RoleTab('/franchise/business', Icons.work_outline, Icons.work, (t) => t.navBusiness),
          RoleTab('/franchise/network', Icons.hub_outlined, Icons.hub, (t) => t.navNetwork),
          RoleTab('/franchise/earnings', Icons.account_balance_wallet_outlined,
              Icons.account_balance_wallet, (t) => t.navEarnings),
          RoleTab('/franchise/more', Icons.grid_view_outlined, Icons.grid_view, (t) => t.navMore),
        ],
      UserRole.admin => [
          RoleTab('/admin/home', Icons.home_outlined, Icons.home, (t) => t.navHome),
          RoleTab('/admin/enquiries', Icons.list_alt_outlined, Icons.list_alt, (t) => t.navEnquiries),
          RoleTab('/admin/business', Icons.work_outline, Icons.work, (t) => t.navBusiness),
          RoleTab('/admin/reports', Icons.bar_chart_outlined, Icons.bar_chart, (t) => t.navReports),
          RoleTab('/admin/more', Icons.grid_view_outlined, Icons.grid_view, (t) => t.navMore),
        ],
    };
