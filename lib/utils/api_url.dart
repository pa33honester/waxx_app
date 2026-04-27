class Api {
  static const baseUrl = "https://www.waxxapp.com/"; // Ex :- http://182.168.19.35:5000/
  static const secretKey = "5TIvw5cpc0"; // Ex :- ssf45sd1fs5d1sdf1s56165s15sdf1s

  // >>>>> >>>>> Admin Setting Api <<<<< <<<<<
  static const adminSetting = "${baseUrl}setting";
  static const fetchSellerProfile = "${baseUrl}seller/fetchSellerProfile";
  static const fetchSellerReels = "${baseUrl}reel/reelsOfSeller";
  static const fetchSellerFollowers = "${baseUrl}follower/getSellerFollowers";

  static const editProfile = "user/update";
  static const userLogin = "user/login";
  static const changeEmailRequest = "user/changeEmail/request";
  static const changeEmailVerify = "user/changeEmail/verify";
  static const changePhone = "user/changePhone";
  static const otpCreate = "OTP/create";
  static const userLoginVerifyOtp = "OTP/otplogin";
  static const otpVerify = "OTP/verify";
  static const checkPassword = "user/checkPassword";
  static const setPassword = "user/setPassword";
  static const sellerSetPassword = "seller/setPassword";
  static const checkUser = "user/checkUser";
  static const reviewCreate = "review/create";
  static const requestCreate = "request/create"; // seller create request
  static const createProduct = "product/create";
  static const sellerAllData = "request/sellerBecomeOrNot";
  static const favoriteUnFavorite = "favorite/favoriteUnfavorite";
  static const followUnfollow = "follower/followUnfollow";
  static const addTOCart = "cart/addToCart";
  static const removeTOCart = "cart/removeProduct";
  static const faq = "FAQ";
  static const userAddAddress = "address/create";
  static const getAllCategory = "category";
  static const attributes = "attributes";
  static const checkOut = "cart/checkOut";
  static const allPromoCode = "promoCode/getAll";

  static const justForYouProduct = "product/justForYouProducts"; // home page just for you
  static const searchProduct = "product/search";
  static const previousSearchProducts = "product/searchProduct";
  static const liveSeller = "liveSeller";
  static const liveHeartbeat = "liveSeller/heartbeat";
  static const uploadShort = "reel/uploadReel";

  /// **************** QUERY(params) URL ********************
  static const userProfile = "user/profile"; // user profile who login
  static const sellerUpdate = "seller/update";
  static const allProductForSeller = "product/allProductForSeller";
  static const sellerUploadedShort = "reel/reelsOfSeller";

  //static const productUpdate = "/product/update"; pela aa hti hve aa url chhe :- updateProductBySeller
  static const updateProductBySeller = "productRequest/updateProductRequest";
  static const sellerProductDetails = "product/detailforSeller";
  static const getShortForUser = "reel/getReelsForUser";
  static const shortsLikeAndDislike = "reel/likeOrDislikeOfReel";
  static const userProductDetails = "product/detail";
  static const getReviewDetails = "review/getreview";
  static const sellerProductDelete = "product/delete";
  static const sellerReelDelete = "reel/deleteReel";
  static const galleryCategory = "product/categorywiseAllProducts";
  static const productSelectOrNot = "product/selectOrNot";
  static const myOrders = "order/orderDetailsForUser";
  static const selectedProductForLive = "product/selectedProducts";
  static const favoriteProducts = "favorite/favoriteProduct";
  static const getAllCartProducts = "cart/getCartProduct";
  static const userUpdateAddress = "address/update";
  static const userSelectAddress = "address/selectOrNot";
  static const newCollection = "product/geAllNewCollection";
  static const getAllAddress = "address/getAllAddress";
  static const getOnlySelectedAddress = "address/selectAddress";
  static const orderCountForSeller = "order/orderCountForSeller";
  static const orderDetailsForSeller = "order/orderDetailsForSeller";
  static const walletCountForSeller = "sellerWallet/getAllAmount";
  static const pendingWalletAmountForSeller = "sellerWallet/sellerPendingAmount";
  static const deliveredOrderAmountForSeller = "sellerWallet/sellerPendingWithdrawableAmount";
  static const sellerTotalEarning = "sellerWallet/sellerEarningAmount";
  static const categoryWiseSubCategory = "subCategory/categoryWiseSubCategory";
  static const userApplyPromoCheck = "promoCodeCheck/checkPromoCode";
  static const createOrderByUser = "order/create";
  static const updateOrderStatusBySeller = "order/updateOrder";
  static const orderCancelByUser = "order/cancelOrderByUser";
  static const ratingAdd = "rate/addRating";
  static const deleteAllCartProduct = "cart/deleteCart";
  static const addressDeleteByUser = "address/delete";
  static const liveSellerList = "liveSeller/liveSellerList";
  static const updatePasswordByUser = "user/updatePassword";
  static const updatePasswordBySeller = "seller/updatePassword";
  static const filterWiseProduct = "product/filterWiseProduct";
  static const getSelectedProductForUser = "liveSeller/getSelectedProducts";
  static const allNotificationList = "notification/list";
  static const deleteAccount = "user/deleteUserAccount";
  static const getAllBank = "bank/getBanks";
  static const fetchCategorySubAttr = "product/fetchCatSubcatAttrData";
  static const placeManualBid = "auctionBid/placeManualBid";
  static const getUserAuctionBids = "auctionBid/getUserAuctionBids";
  static const getProductWiseUserBids = "auctionBid/getProductWiseUserBids";
  static const getSellerAuctionBids = "auctionBid/getSellerAuctionBids";
  static const openai = "https://api.openai.com/v1/chat/completions";
  static const confirmCodOrderItemBySeller = "order/confirmCodOrderItemBySeller";
  static const getReportreason = "reportReason/getReportreason";
  static const reportReel = "reportToReel/reportReel";
  static const createWithdraw = "withdrawRequest/initiateCashOut";
  static const getWithdrawalRequestsBySeller = "withdrawRequest/getWithdrawalRequestsBySeller";
  static const getSellerWalletHistory = "sellerWallet/retrieveSellerWalletHistory";
  static const withdrawalList = "withdraw/withdrawalList";
  static const sellerUpdateOrderItemStatus = "order/modifyOrderItemStatus";
  static const getAuctionProducts = "product/getAuctionProducts";
  static const getRelatedProductsByCategory = "product/getRelatedProductsByCategory";

  // Unified search (products + sellers + live shows + reels)
  static const searchAll = "search/all";

  // Pending wins — bundled-order view for the buyer's unpaid auction / offer
  // wins grouped by seller. Reuses the existing order listing endpoint via
  // the "Bundle Pending Payment" item status.
  static const myOrdersList = "order/ordersOfUser";

  // Proxy / auto-bid
  static const setAutoBid = "autoBid/setAutoBid";
  static const cancelAutoBid = "autoBid/cancel";
  static const getAutoBid = "autoBid/getAutoBid";
  static const myActiveAutoBids = "autoBid/myActive";

  // Offers (buyer↔seller negotiation on static listings)
  static const createOffer = "offer/create";
  static const withdrawOffer = "offer/withdraw";
  static const acceptOffer = "offer/accept";
  static const counterOffer = "offer/counter";
  static const declineOffer = "offer/decline";
  static const getReceivedOffers = "offer/received";
  static const getSentOffers = "offer/sent";
  static const sendProductLikedNotification = "notification/sendProductLikedNotification";
  static const featuredProducts = "product/featuredProducts";

  // Giveaways
  static const startGiveaway = "giveaway/start";
  static const enterGiveaway = "giveaway/enter";
  static const drawGiveaway = "giveaway/draw";
  static const giveawaysByLive = "giveaway/byLive";
  static const sellerGiveawayHistory = "giveaway/sellerHistory";
  static const myGiveawayWins = "giveaway/myWins";

  // Live scheduling
  static const scheduleLive = "liveSeller/schedule";
  static const getScheduledLivesBySeller = "liveSeller/scheduledBySeller";
  static const getUpcomingLivesForUser = "liveSeller/upcoming";
  static const setLiveReminder = "liveSeller/setReminder";
  static const cancelLiveReminder = "liveSeller/cancelReminder";

  // static String getDomainFromURL(String url) {
  //   final uri = Uri.parse(url);
  //   String host = uri.host;
  //   if (host.startsWith("www.")) {
  //     return host.substring(4);
  //   }
  //   print("object::::::host uri:::$host");
  //   return host;
  // }
}
