/*
 * (c) iHunter, 2012
 *
 * Based on Yamaguchi Tatsuya's LinkedLabel code.
 */
#import "IHNHyperlinkLabel.h"

@interface IHNHyperlinkLabel ()
{
    CGRect cachedTextRect;
}
@end

#pragma mark -
@implementation IHNHyperlinkLabel
@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    self.userInteractionEnabled = YES;
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    self.userInteractionEnabled = YES;
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([self.text length] == 0)
        return;
    
    // Drawing underline.
    CGPoint origin = self.bounds.origin;
    CGFloat fontSize = self.font.pointSize;
    CGSize size = [self.text sizeWithFont:self.font minFontSize:self.minimumFontSize
                              actualFontSize:&fontSize forWidth:self.bounds.size.width
                               lineBreakMode:self.lineBreakMode];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetShadowWithColor(context, self.shadowOffset, 0, self.shadowColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.isHighlighted ?
                                     self.highlightedTextColor.CGColor :
                                     self.textColor.CGColor);
    CGContextMoveToPoint(context, origin.x, origin.y + size.height - 2);
    CGContextAddLineToPoint(context, origin.x + size.width,
                            origin.y + size.height - 2);
    CGContextStrokePath(context);
    
    cachedTextRect = CGRectMake(origin.x, origin.y, size.width, size.height);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    self.highlighted = CGRectContainsPoint(cachedTextRect, [touch locationInView:self]);
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    self.highlighted = CGRectContainsPoint(cachedTextRect, [touch locationInView:self]);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if (CGRectContainsPoint(cachedTextRect, [touch locationInView:self]))
        [delegate ihn_hyperlinkLabelTouched:self];
    self.highlighted = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
}
@end
