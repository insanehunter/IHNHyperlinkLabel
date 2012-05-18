/*
 * (c) iHunter, 2012
 */
#import <UIKit/UIKit.h>
@class IHNHyperlinkLabel;


@protocol IHNHyperlinkLabelDelegate
- (void) ihn_hyperlinkLabelTouched:(IHNHyperlinkLabel *)label;
@end


// Underlined UILabel looking like a hyperlink.
// Supposed to be a used as a base class for a label in Interface Builder.
@interface IHNHyperlinkLabel : UILabel
@property(nonatomic, weak) IBOutlet id<IHNHyperlinkLabelDelegate> delegate;
@end
