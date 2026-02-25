class Api {
  static const baseUrl = "Enter Your Base Url"; // Ex :- http://182.168.19.35:5000/
  static const secretKey = "Enter Your Secret Key"; // Ex :- ssf45sd1fs5d1sdf1s56165s15sdf1s

  // >>>>> >>>>> Admin Setting Api <<<<< <<<<<
  static const adminSetting = "${baseUrl}setting";
  static const fetchSellerProfile = "${baseUrl}seller/fetchSellerProfile";
  static const fetchSellerReels = "${baseUrl}reel/reelsOfSeller";
  static const fetchSellerFollowers = "${baseUrl}follower/getSellerFollowers";

  static const editProfile = "user/update";
  static const userLogin = "user/login";
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
  static const featuredProducts = "product/featuredProducts";

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
