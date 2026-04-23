import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_document_verification.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_email_verify.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerAccount/seller_store_details.dart';
import 'package:waxxapp/View/MyApp/Seller/SellerOrder/OutOfDeliveryOrders/out_of_delivered_order_details.dart';
import 'package:waxxapp/View/UserLogin/mobile_login/view/fill_profile_screen.dart';
import 'package:waxxapp/View/UserLogin/mobile_login/view/mobile_login_screen.dart';
import 'package:waxxapp/View/UserLogin/mobile_login/view/verify_otp_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/condition_page.dart';
import 'package:waxxapp/seller_pages/listing/view/description_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/item_location_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/item_specific_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/listing_summary.dart';
import 'package:waxxapp/seller_pages/listing/view/offers_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/photos_edit_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/preferences_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/preview_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/pricing_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/sub_category_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/title_edit_screen.dart';
import 'package:waxxapp/seller_pages/listing/view/category_screen.dart';
import 'package:waxxapp/seller_pages/order_payment_page/view/order_payment_view.dart';
import 'package:waxxapp/seller_pages/select_product_for_streame/view/select_product_for_view.dart';
import 'package:waxxapp/seller_pages/seller_catalogs_page/view/seller_catalogs_view.dart';
import 'package:waxxapp/seller_pages/seller_product_details_page/seller_product_details_view.dart';
import 'package:waxxapp/seller_pages/seller_wallet_page/view/seller_wallet_history_page.dart';
import 'package:waxxapp/seller_pages/seller_wallet_page/view/seller_wallet_view.dart';
import 'package:waxxapp/seller_pages/seller_withdraw_history_page/view/seller_withdraw_history_view.dart';
import 'package:waxxapp/user_pages/bottom_bar_page/view/bottom_bar_view.dart';
import 'package:waxxapp/user_pages/home_page/view/home_view.dart';
import 'package:waxxapp/user_pages/language_page/view/language_view.dart';
import 'package:waxxapp/user_pages/popular_products_page/view/popular_product_view_all.dart';
import 'package:waxxapp/user_pages/setting_page/view/setting_view.dart';
import 'package:waxxapp/utils/CoustomWidget/Page_devided/home_category_view_all.dart';
import 'package:waxxapp/utils/CoustomWidget/Page_devided/select_product_when_create_reels.dart';
import 'package:get/get.dart';
import '../View/MyApp/AppPages/cart_page.dart';
import '../View/MyApp/AppPages/chat_page.dart';
import '../View/MyApp/AppPages/cheak_out.dart';
import '../View/MyApp/AppPages/gallary.dart';
import '../View/MyApp/AppPages/live_seeling_consumer.dart';
import '../View/MyApp/AppPages/message.dart';
import '../View/MyApp/AppPages/my_favorite.dart';
import '../View/MyApp/AppPages/notification.dart';
import '../View/MyApp/AppPages/product_detail.dart';
import '../View/MyApp/AppPages/product_reviews.dart';
import '../View/MyApp/AppPages/search_page.dart';
import '../View/MyApp/AppPages/show_filtered_product.dart';
import '../View/MyApp/Profile/MyAddress/address.dart';
import '../View/MyApp/Profile/MyAddress/new_address.dart';
import '../View/MyApp/Profile/MyAddress/update_address.dart';
import '../View/MyApp/Profile/MyOrder/cancel_order_by_user.dart';
import '../View/MyApp/Profile/MyOrder/my_order.dart';
import '../View/MyApp/Profile/PasswordManager/change_password.dart';
import '../View/MyApp/Profile/PasswordManager/user_create_password.dart';
import '../View/MyApp/Profile/PasswordManager/user_enter_otp.dart';
import '../View/MyApp/Profile/PasswordManager/user_forgot_password.dart';
import '../View/MyApp/Profile/add_new_card.dart';
import '../View/MyApp/Profile/edit_profile.dart';
import '../View/MyApp/Profile/legal_and_policies.dart';
import '../View/MyApp/Profile/main_profile.dart';
import '../View/MyApp/Profile/my_payment.dart';
import '../View/MyApp/Profile/security.dart';
import '../View/MyApp/Seller/AddProduct/seller_edit_product.dart';
import '../View/MyApp/Seller/LiveSelling/fake_live_selling.dart';
import '../View/MyApp/Seller/LiveSelling/live_streaming.dart';
import '../View/MyApp/Seller/Reels/create_short.dart';
import '../View/MyApp/Seller/Reels/shorts_preview.dart';
import '../View/MyApp/Seller/Reels/uploaded_reels.dart';
import '../View/MyApp/Seller/SellerAccount/seller_account_details.dart';
import '../View/MyApp/Seller/SellerAccount/seller_account_varification.dart';
import '../View/MyApp/Seller/SellerAccount/seller_address_detail.dart';
import '../View/MyApp/Seller/SellerAccount/seller_enter_otp.dart';
import '../View/MyApp/Seller/SellerAccount/seller_login.dart';
import '../View/MyApp/Seller/SellerAccount/terms&condition.dart';
import '../View/MyApp/Seller/SellerOrder/CancelledOrder/cancelled_order.dart';
import '../View/MyApp/Seller/SellerOrder/CancelledOrder/cancelled_order_details.dart';
import '../View/MyApp/Seller/SellerOrder/ConfirmedOrders/confirmed_orders.dart';
import '../View/MyApp/Seller/SellerOrder/ConfirmedOrders/order_confirm_by_seller.dart';
import '../View/MyApp/Seller/SellerOrder/DeliveredOrder/delivered_order.dart';
import '../View/MyApp/Seller/SellerOrder/DeliveredOrder/delivered_order_details.dart';
import '../View/MyApp/Seller/SellerOrder/OutOfDeliveryOrders/out_of_delivery_orders.dart';
import '../View/MyApp/Seller/SellerOrder/PendingOrder/pending_order_proceed.dart';
import '../View/MyApp/Seller/SellerOrder/PendingOrder/pending_orders.dart';
import '../View/MyApp/Seller/SellerPasswordMager/seller_change_password.dart';
import '../View/MyApp/Seller/SellerPasswordMager/seller_create_password.dart';
import '../View/MyApp/Seller/SellerPasswordMager/seller_forgot_enter_otp.dart';
import '../View/MyApp/Seller/SellerPasswordMager/seller_forgot_password.dart';
import '../View/MyApp/Seller/SellerProfile/seller_address.dart';
import '../View/MyApp/Seller/SellerProfile/seller_bank_account.dart';
import '../View/MyApp/Seller/SellerProfile/seller_edit_address.dart';
import '../View/MyApp/Seller/SellerProfile/seller_edit_bank.dart';
import '../View/MyApp/Seller/SellerWallet/payment_delivered_amount.dart';
import '../View/MyApp/Seller/SellerWallet/payment_pending.dart';
import '../View/MyApp/Seller/SellerWallet/total_earning.dart';
import '../View/OnboardingScreens/page_manage.dart';
import '../View/OnboardingScreens/spalsh_screen.dart';
import '../View/UserLogin/create_account.dart';
import '../View/UserLogin/create_new_password.dart';
import '../View/UserLogin/demo_sign_in.dart';
import '../View/UserLogin/forgot_enter_otp.dart';
import '../View/UserLogin/forgot_password.dart';
import '../View/UserLogin/sign_in_email.dart';
import '../View/UserLogin/sign_up.dart';
import '../seller_pages/my_wallet_page/view/my_wallet_view.dart';
import '../seller_pages/seller_add_product_page/view/seller_add_product_view.dart';
import '../seller_pages/seller_edit_profile_page/view/seller_edit_profile_view.dart';
import '../seller_pages/seller_order_page/view/my_orders.dart';
import '../seller_pages/seller_profile_page/view/seller_profile_view.dart';
import '../user_pages/help_and_support_page/view/help_and_support_view.dart';
import '../seller_pages/schedule_live_page/view/schedule_live_view.dart';
import '../user_pages/giveaway/view/my_giveaway_wins_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: "/MyGiveawayWins",
      page: () => const MyGiveawayWinsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/",
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: "/PageManage",
      page: () => const PageManage(),
    ),
    GetPage(
      name: "/SignIn",
      page: () => const SignIn(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CreateAccount",
      page: () => CreateAccount(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SignInEmail",
      page: () => const SignInEmail(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SignUp",
      page: () => SignUp(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/EnterOtp",
      page: () => EnterOtp(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ForgotPassword",
      page: () => const ForgotPassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CreateNewPassword",
      page: () => CreateNewPassword(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: "/BottomTabBar",
      // just shortcut remove after complate
      page: () => const BottomBarView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/HomePage",
      page: () => const HomeView(),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: "/Notifications",
    //   page: () => const Notifications(),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: "/Message",
      page: () => const Message(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ChatPage",
      page: () => const ChatPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SearchPage",
      page: () => const SearchPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ProductDetail",
      page: () => const ProductDetail(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ProductReviews",
      page: () => const ProductReviews(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Gallery",
      page: () => const Gallery(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/LiveSellingConsumer",
      page: () => const LiveSellingConsumer(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CartPage",
      page: () => const CartPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CheckOut",
      page: () => const CheckOut(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/MyOrder",
      page: () => const MyOrder(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/MyFavorite",
      page: () => const MyFavorite(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/MainProfile",
      page: () => const MainProfile(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/EditProfile",
      page: () => const EditProfile(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/UserAddress",
      page: () => const UserAddress(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/NewAddress",
      page: () => const NewAddress(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/UpdateAddress",
      page: () => const UpdateAddress(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/MyPayment",
      page: () => const MyPayment(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/AddNewCard",
      page: () => const AddNewCard(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ChangePassword",
      page: () => ChangePassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/UserForgotPassword",
      page: () => UserForgotPassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Language",
      page: () => const LanguageView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/LegalAndPolicies",
      page: () => const LegalAndPolicies(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Notifications",
      page: () => Notifications(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Security",
      page: () => const Security(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/HelpAndSupport",
      page: () => const HelpAndSupportView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SettingView",
      page: () => const SettingView(),
      transition: Transition.rightToLeft,
    ),

    /// ================= SELLER ACCOUNT ======================

    GetPage(
      name: "/SellerLogin",
      page: () => const SellerLogin(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerEnterOtp",
      page: () => SellerEnterOtp(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerAddressDetails",
      page: () => const SellerAddressDetails(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerAccountDetails",
      page: () => SellerAccountDetails(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/TermsAndConditions",
      page: () => const TermsAndConditions(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerAccountVerification",
      page: () => const SellerAccountVerification(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerProfile",
      page: () => const SellerProfileView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerEditProfile",
      page: () => const SellerEditProfileView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerAddress",
      page: () => const SellerAddress(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerEditAddress",
      page: () => const SellerEditAddress(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerBankAccount",
      page: () => const SellerBankAccount(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerEditBank",
      page: () => SellerEditBank(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerCatalogScreen",
      page: () => const SellerCatalogsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/AddProduct",
      page: () => const AddProduct(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerProductDetails",
      page: () => const SellerProductDetailsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/EditProduct",
      page: () => const EditProduct(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/MyWallet",
      page: () => const MyWalletView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/LiveStreaming",
      page: () => const LiveStreaming(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/FakeLiveSelling",
      page: () => const FakeLiveSelling(),
      transition: Transition.rightToLeft,
    ),

    /// ================= ORDERS ======================

    GetPage(
      name: "/MyOrders",
      page: () => const MyOrders(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PendingOrders",
      page: () => const PendingOrders(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PendingOrderProceed",
      page: () => PendingOrderProceed(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CancelOrderByUser",
      page: () => const CancelOrderByUser(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/OrderConfirmBySeller",
      page: () => OrderConfirmBySeller(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ConfirmedOrders",
      page: () => const ConfirmedOrders(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/OutOfDeliveryOrders",
      page: () => const OutOfDeliveryOrders(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/DeliveredOrder",
      page: () => const DeliveredOrder(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/DeliveredOrderDetails",
      page: () => DeliveredOrderDetails(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/OutOfDeliveredOrderDetails",
      page: () => OutOfDeliveryOrdersDetails(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CancelledOrder",
      page: () => const CancelledOrder(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CancelledOrderDetails",
      page: () => CancelledOrderDetails(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PaymentDeliveredAmount",
      page: () => const PaymentDeliveredAmount(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PaymentPending",
      page: () => const PaymentPending(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/TotalEarning",
      page: () => const TotalEarning(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/UserEnterOtp",
      page: () => UserEnterOtp(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/UserCreatePassword",
      page: () => UserCreatePassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerChangePassword",
      page: () => SellerChangePassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerForgotPassword",
      page: () => SellerForgotPassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerForgotEnterOtp",
      page: () => SellerForgotEnterOtp(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerCreatePassword",
      page: () => SellerCreatePassword(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ShowFilteredProduct",
      page: () => const ShowFilteredProduct(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/UploadShort",
      page: () => const UploadedShort(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/CreateShort",
      page: () => CreateShort(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ShortsPreview",
      page: () => const ShortsPreview(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PaymentPage",
      page: () => OrderPaymentView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ListingPage",
      page: () => ConditionPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ListingSummary",
      page: () => ListingSummary(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PhotosEdit",
      page: () => PhotosDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/TitleEdit",
      page: () => TitleEditScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Category",
      page: () => CategoryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SubCategory",
      page: () => SubCategoryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ItemSpecific",
      page: () => ItemSpecificScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Description",
      page: () => DescriptionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Pricing",
      page: () => PricingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Offers",
      page: () => OffersScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/Preferences",
      page: () => PreferencesScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ItemLocation",
      page: () => ItemLocationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PreviewScreen",
      page: () => PreviewScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/editListingSummary",
      page: () => ListingSummary(),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: "/ProductDetailNew",
    //   page: () => ProductDetailNew(),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: "/SelectProductForStream",
      page: () => SelectProductForStreamView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/sellerWithdrawPage",
      page: () => SellerWithdrawHistoryView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/sellerWalletPage",
      page: () => SellerWalletView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/sellerWalletHistoryPage",
      page: () => SellerWalletHistoryView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/MobileLoginScreen",
      page: () => MobileLoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/VerifyOtpScreen",
      page: () => VerifyOtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/FillProfileScreen",
      page: () => FillProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/PopularProductViewAllScreen",
      page: () => PopularProductViewAllScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerEmailVerify",
      page: () => SellerEmailVerify(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerStoreDetails",
      page: () => SellerStoreDetails(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SellerDocumentVerification",
      page: () => SellerDocumentVerification(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/SelectProductWhenCreateReels",
      page: () => SelectProductWhenCreateReels(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/HomeCategoryViewAll",
      page: () => HomeCategoryViewAll(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: "/ScheduleLive",
      page: () => const ScheduleLiveView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
