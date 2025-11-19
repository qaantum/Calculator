package com.cryptatext.premium

import android.app.Activity
import android.content.Context
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.BillingFlowParams
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.ProductDetails
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.PurchasesUpdatedListener
import com.android.billingclient.api.QueryProductDetailsParams
import com.android.billingclient.api.QueryPurchasesParams
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

interface PremiumManager {
    val isPremium: StateFlow<Boolean>
    suspend fun setPremium(isPremium: Boolean)
    fun startPurchaseFlow(activity: Any)
}

class MockPremiumManager : PremiumManager {
    private val _isPremium = MutableStateFlow(false)
    override val isPremium: StateFlow<Boolean> = _isPremium.asStateFlow()

    override suspend fun setPremium(isPremium: Boolean) {
        _isPremium.value = isPremium
    }
    
    override fun startPurchaseFlow(activity: Any) {
        _isPremium.value = true
    }
}

class RealPremiumManager(
    context: Context,
    private val scope: CoroutineScope
) : PremiumManager, PurchasesUpdatedListener {

    private val _isPremium = MutableStateFlow(false)
    override val isPremium: StateFlow<Boolean> = _isPremium.asStateFlow()

    private val billingClient = BillingClient.newBuilder(context)
        .setListener(this)
        .enablePendingPurchases()
        .build()

    private var productDetails: ProductDetails? = null
    private val premiumProductId = "com.cryptatext.premium" // Must match Play Console

    init {
        startConnection()
    }

    private fun startConnection() {
        billingClient.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    queryPurchases()
                    queryProductDetails()
                }
            }

            override fun onBillingServiceDisconnected() {
                // Retry connection logic could go here
            }
        })
    }

    private fun queryPurchases() {
        val params = QueryPurchasesParams.newBuilder()
            .setProductType(BillingClient.ProductType.INAPP)
            .build()

        billingClient.queryPurchasesAsync(params) { billingResult, purchases ->
            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                processPurchases(purchases)
            }
        }
    }

    private fun queryProductDetails() {
        val productList = listOf(
            QueryProductDetailsParams.Product.newBuilder()
                .setProductId(premiumProductId)
                .setProductType(BillingClient.ProductType.INAPP)
                .build()
        )
        val params = QueryProductDetailsParams.newBuilder()
            .setProductList(productList)
            .build()

        billingClient.queryProductDetailsAsync(params) { billingResult, productDetailsList ->
            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                productDetails = productDetailsList.find { it.productId == premiumProductId }
            }
        }
    }

    override fun startPurchaseFlow(activity: Any) {
        if (activity is Activity) {
            val details = productDetails ?: return
            val flowParams = BillingFlowParams.newBuilder()
                .setProductDetailsParamsList(
                    listOf(
                        BillingFlowParams.ProductDetailsParams.newBuilder()
                            .setProductDetails(details)
                            .build()
                    )
                )
                .build()
            billingClient.launchBillingFlow(activity, flowParams)
        }
    }

    override fun onPurchasesUpdated(billingResult: BillingResult, purchases: List<Purchase>?) {
        if (billingResult.responseCode == BillingClient.BillingResponseCode.OK && purchases != null) {
            processPurchases(purchases)
        }
    }

    private fun processPurchases(purchases: List<Purchase>) {
        scope.launch {
            val hasPremium = purchases.any { purchase ->
                purchase.products.contains(premiumProductId) && purchase.purchaseState == Purchase.PurchaseState.PURCHASED
            }
            _isPremium.emit(hasPremium)
            
            // Acknowledge purchases if needed (for non-consumables, usually handled automatically or just verified)
            // For this simple implementation, we just check existence.
            purchases.forEach { purchase ->
                if (purchase.purchaseState == Purchase.PurchaseState.PURCHASED && !purchase.isAcknowledged) {
                    val acknowledgePurchaseParams = com.android.billingclient.api.AcknowledgePurchaseParams.newBuilder()
                        .setPurchaseToken(purchase.purchaseToken)
                        .build()
                    billingClient.acknowledgePurchase(acknowledgePurchaseParams) { _ -> }
                }
            }
        }
    }

    override suspend fun setPremium(isPremium: Boolean) {
        // No-op for real manager, controlled by billing
    }
}
