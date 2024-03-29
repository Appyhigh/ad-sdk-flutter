package com.appyhigh.plugins.adsdk

import android.graphics.Color
import android.content.res.ColorStateList
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

internal class CustomNativeAd(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: Map<String, Any>?): NativeAdView {
        val adView = LayoutInflater.from(context).inflate(R.layout.native_ad_layout, null) as NativeAdView

         // Set the media view.
        adView.mediaView =
        adView.findViewById<View>(R.id.ad_media) as MediaView

        // Set other ad assets.
        adView.headlineView =
            adView.findViewById(R.id.ad_headline)
        adView.bodyView =
            adView.findViewById(R.id.ad_body)
        adView.callToActionView =
            adView.findViewById(R.id.ad_call_to_action)
        adView.iconView =
            adView.findViewById(R.id.ad_app_icon)
        adView.priceView =
            adView.findViewById(R.id.ad_price)
        adView.starRatingView =
            adView.findViewById(R.id.ad_stars)
        adView.storeView =
            adView.findViewById(R.id.ad_store)
        adView.advertiserView =
            adView.findViewById(R.id.ad_advertiser)

        // The headline and mediaContent are guaranteed to be in every NativeAd.
        (adView.headlineView as TextView?)!!.text = nativeAd.headline
        adView.mediaView!!.setMediaContent(nativeAd.mediaContent!!)
        (adView.headlineView as TextView?)!!.setTextColor(Color.parseColor((customOptions!!["textColor"] as String)))


        if (nativeAd.callToAction == null) {
            adView.callToActionView!!.visibility = View.INVISIBLE
        } else {
            adView.callToActionView!!.visibility = View.VISIBLE
            (adView.callToActionView as Button?)!!.text = nativeAd.callToAction
            (adView.callToActionView as Button?)!!.backgroundTintList = ColorStateList.valueOf(Color.parseColor((customOptions!!["buttonColor"] as String)));
        }
        if (nativeAd.icon == null) {
            adView.iconView!!.visibility = View.GONE
        } else {
            (adView.iconView as ImageView?)!!.setImageDrawable(
                nativeAd.icon!!.drawable
            )
            adView.iconView!!.visibility = View.VISIBLE
        }
        if (nativeAd.price == null) {
            adView.priceView!!.visibility = View.INVISIBLE
        } else {
            adView.priceView!!.visibility = View.VISIBLE
            (adView.priceView as TextView?)!!.text = nativeAd.price
            (adView.priceView as TextView?)!!.setTextColor(Color.parseColor((customOptions!!["textColor"] as String)))
        }
        if (nativeAd.store == null) {
            adView.storeView!!.visibility = View.INVISIBLE
        } else {
            adView.storeView!!.visibility = View.VISIBLE
            (adView.storeView as TextView?)!!.text = nativeAd.store
            (adView.storeView as TextView?)!!.setTextColor(Color.parseColor((customOptions!!["textColor"] as String)))
        }
        if (nativeAd.starRating == null) {
            adView.starRatingView!!.visibility = View.INVISIBLE
        } else {
            (adView.starRatingView as RatingBar?)!!.rating = nativeAd.starRating!!.toFloat()
            adView.starRatingView!!.visibility = View.VISIBLE
        }
        if (nativeAd.advertiser == null) {
            adView.advertiserView!!.visibility = View.INVISIBLE
        } else {
            adView.advertiserView!!.visibility = View.VISIBLE
            (adView.advertiserView as TextView?)!!.text = nativeAd.advertiser
            (adView.advertiserView as TextView?)!!.setTextColor(Color.parseColor((customOptions!!["textColor"] as String)))
        }

        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        adView.setNativeAd(nativeAd)
        return adView
    }
}