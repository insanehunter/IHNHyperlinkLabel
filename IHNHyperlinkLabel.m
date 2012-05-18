/*
Copyright (C) 2012 Sergei Cherepanov. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name of the author nor the names of its contributors may be used
  to endorse or promote products derived from this software without specific
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
