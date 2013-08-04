package com.pdf
{
	import com.pdf.skin.ProgressBarSkin;
	import com.pdf.skin.ProgressBarTrackSkin;
	
	import mx.controls.ProgressBar;
	import mx.core.mx_internal;

	public class CustomProgressBar extends ProgressBar
	{
		override public function stylesInitialized():void
		{
			super.stylesInitialized();
			this.setStyle("barSkin",Class(ProgressBarSkin));
			this.setStyle("trackSkin",Class(ProgressBarTrackSkin));
		}
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			
			// center the label field on the circle in the background image 
			
			if (mx_internal::_labelField != null) {
				mx_internal::_labelField.move(7, 14);
			}
		}
	}
}