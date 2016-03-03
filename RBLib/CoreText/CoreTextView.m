//
//  CoreTextView.m
//  RBLib
//
//  Created by zhouruibin on 16/3/3.
//  Copyright © 2016年 zruibin. All rights reserved.
//

#import "CoreTextView.h"
#import <CoreText/CoreText.h>
#import "RBMacros.h"

@interface CoreTextView ()

@end

@implementation CoreTextView

- (void)drawRect:(CGRect)rect
{
    switch (_showType) {
        case CoreTextBase:
            [self characterAttribute];
            break;
        case CoreTextParagraph:
            [self paragraphStyle];
            break;
        case CoreTextLine:
            [self drawLine];
            break;
        case CoreTextLineBounds:
            [self drawBounds];
            break;
        case CoreTextBlend:
            [self drawCharAndPicture];
            break;
            
        default:
            break;
    }
}

- (void)setShowType:(CoreTextShowType)showType
{
    _showType = showType;
    [self setNeedsDisplay];
}

#pragma mark - 基本用法

-(void)characterAttribute
{
    NSString *str = @"This is a test of characterAttribute. 中文字符";
    NSMutableAttributedString *mabstring = [[NSMutableAttributedString alloc]initWithString:str];
    
    [mabstring beginEditing];
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTCharacterShapeAttributeName value:(id)num range:NSMakeRange(0, 4)];
     */
    /*
     //设置字体属性
     CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 40, NULL);
     [mabstring addAttribute:(id)kCTFontAttributeName value:(id)font range:NSMakeRange(0, 4)];
     */
    /*
     //设置字体简隔 eg:test
     long number = 10;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(10, 4)];
     */
    
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTLigatureAttributeName value:(id)num range:NSMakeRange(0, [str length])];
     */
    /*
     //设置字体颜色
     [mabstring addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 9)];
     */
    /*
     //设置字体颜色为前影色
     CFBooleanRef flag = kCFBooleanTrue;
     [mabstring addAttribute:(id)kCTForegroundColorFromContextAttributeName value:(id)flag range:NSMakeRange(5, 10)];
     */
    
    /*
     //设置空心字
     long number = 2;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTStrokeWidthAttributeName value:(id)num range:NSMakeRange(0, [str length])];
     
     //设置空心字颜色
     [mabstring addAttribute:(id)kCTStrokeColorAttributeName value:(id)[UIColor greenColor].CGColor range:NSMakeRange(0, [str length])];
     */
    
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTSuperscriptAttributeName value:(id)num range:NSMakeRange(3, 1)];
     */
    
    /*
     //设置斜体字
     CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:20].fontName, 14, NULL);
     [mabstring addAttribute:(id)kCTFontAttributeName value:(id)font range:NSMakeRange(0, 4)];
     */
    
    /*
     //下划线
     [mabstring addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] range:NSMakeRange(0, 4)];
     //下划线颜色
     [mabstring addAttribute:(id)kCTUnderlineColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 4)];
     */
    
    
    //对同一段字体进行多属性设置
    //红色
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)[UIColor redColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
    //斜体
    CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:20].fontName, 40, NULL);
    [attributes setObject:(__bridge id)font forKey:(id)kCTFontAttributeName];
    //下划线
    [attributes setObject:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] forKey:(id)kCTUnderlineStyleAttributeName];
    
    [mabstring addAttributes:attributes range:NSMakeRange(0, 4)];
    
    
    
    NSRange kk = NSMakeRange(0, 4);
    
    NSDictionary * dc = [mabstring attributesAtIndex:0 effectiveRange:&kk];
    
    [mabstring endEditing];
    
    DLog(@"value = %@",dc);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL ,CGRectMake(10 , 0 ,self.bounds.size.width-10 , self.bounds.size.height-10));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);
    
    //x，y轴方向移动
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    CTFrameDraw(frame,context);
    
    CGPathRelease(Path);
    CFRelease(framesetter);
}

#pragma mark - 段落样子CTParagraphStyle

-(void)paragraphStyle
{
    NSString *src = @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 2、生成一个CTFramesetterRef对象，然后创建一个CGPath对象，这个Path对象用于表示可绘制区域坐标值、长宽。 3、使用上面生成的setter和path生成一个CTFrameRef对象，这个对象包含了这两个对象的信息（字体信息、坐标信息），它就可以使用CTFrameDraw方法绘制了。";
    
    //修改windows回车换行为mac的回车换行
    //src = [src stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    NSMutableAttributedString * mabstring = [[NSMutableAttributedString alloc]initWithString:src];
    
    long slen = [mabstring length];
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTRightTextAlignment;//kCTNaturalTextAlignment;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    //首行缩进
    CGFloat fristlineindent = 24.0f;
    CTParagraphStyleSetting fristline;
    fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristline.value = &fristlineindent;
    fristline.valueSize = sizeof(float);
    
    //段缩进
    CGFloat headindent = 10.0f;
    CTParagraphStyleSetting head;
    head.spec = kCTParagraphStyleSpecifierHeadIndent;
    head.value = &headindent;
    head.valueSize = sizeof(float);
    
    //段尾缩进
    CGFloat tailindent = 50.0f;
    CTParagraphStyleSetting tail;
    tail.spec = kCTParagraphStyleSpecifierTailIndent;
    tail.value = &tailindent;
    tail.valueSize = sizeof(float);
    
    //tab
    CTTextAlignment tabalignment = kCTJustifiedTextAlignment;
    CTTextTabRef texttab = CTTextTabCreate(tabalignment, 24, NULL);
    CTParagraphStyleSetting tab;
    tab.spec = kCTParagraphStyleSpecifierTabStops;
    tab.value = &texttab;
    tab.valueSize = sizeof(CTTextTabRef);
    
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByTruncatingMiddle;//kCTLineBreakByWordWrapping;//换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    //多行高
    CGFloat MutiHeight = 10.0f;
    CTParagraphStyleSetting Muti;
    Muti.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    Muti.value = &MutiHeight;
    Muti.valueSize = sizeof(float);
    
    //最大行高
    CGFloat MaxHeight = 5.0f;
    CTParagraphStyleSetting Max;
    Max.spec = kCTParagraphStyleSpecifierLineHeightMultiple;
    Max.value = &MaxHeight;
    Max.valueSize = sizeof(float);
    
    //行距
    CGFloat _linespace = 5.0f;
    CTParagraphStyleSetting lineSpaceSetting;
    lineSpaceSetting.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceSetting.value = &_linespace;
    lineSpaceSetting.valueSize = sizeof(float);
    
    //段前间隔
    CGFloat paragraphspace = 5.0f;
    CTParagraphStyleSetting paragraph;
    paragraph.spec = kCTParagraphStyleSpecifierLineSpacing;
    paragraph.value = &paragraphspace;
    paragraph.valueSize = sizeof(float);
    
    //书写方向
    CTWritingDirection wd = kCTWritingDirectionRightToLeft;
    CTParagraphStyleSetting writedic;
    writedic.spec = kCTParagraphStyleSpecifierBaseWritingDirection;
    writedic.value = &wd;
    writedic.valueSize = sizeof(CTWritingDirection);
    
    //组合设置
    CTParagraphStyleSetting settings[] = {
        alignmentStyle,
        fristline,
        head,
        tail,
        tab,
        lineBreakMode,
        Muti,
        Max,
        lineSpaceSetting,
        writedic,
//        indentSetting
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 11);
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName];
    
    // set attributes to attributed string
//    [mabstring addAttributes:attributes range:NSMakeRange(0, slen)];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    //坐标点在左下角
    CGPathAddRect(Path, NULL ,CGRectMake(10 , 10 ,self.bounds.size.width-20 , self.bounds.size.height-20));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);
    
    //x，y轴方向移动
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    CTFrameDraw(frame,context);
    
    CGPathRelease(Path);
    CFRelease(framesetter);
}

#pragma mark - 行 CTLineRef

- (void)drawLine
{
    NSString *src = @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 ";
    
    NSMutableAttributedString * mabstring = [[NSMutableAttributedString alloc]initWithString:src];
    
    long slen = [mabstring length];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    //坐标点在左下角
    CGPathAddRect(Path, NULL ,CGRectMake(10 , 10 ,self.bounds.size.width-20 , self.bounds.size.height-20));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //得到frame中的行数组
    CFArrayRef rows = CTFrameGetLines(frame);
    CGRect rect = self.bounds;
    
    if (rows) {
        const CFIndex numberOfLines = CFArrayGetCount(rows);
        const CGFloat fontLineHeight = [UIFont systemFontOfSize:20].lineHeight;
        CGFloat textOffset = 0;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y+[UIFont systemFontOfSize:20].ascender);
        CGContextSetTextMatrix(ctx, CGAffineTransformMakeScale(1,-1));
        
        for (CFIndex lineNumber=0; lineNumber<numberOfLines; lineNumber++) {
            CTLineRef line = CFArrayGetValueAtIndex(rows, lineNumber);
            float flush;
            switch (2) {
                case UITextAlignmentCenter:	flush = 0.5;	break; //1
                case UITextAlignmentRight:	flush = 1;		break; //2
                case UITextAlignmentLeft:  //0
                default:
                    flush = 0;
                    break;
            }
            
            CGFloat penOffset = CTLineGetPenOffsetForFlush(line, flush, rect.size.width);
            DLog(@"penOffset = %f",penOffset);
            CGContextSetTextPosition(ctx, penOffset, textOffset);//在偏移量x,y上打印
            CTLineDraw(line, ctx);//draw 行文字
            textOffset += fontLineHeight;
        }
        
        CGContextRestoreGState(ctx);
        
    }
}

-(void)drawBounds
{
    NSString *src = @"其实流程是这样的： 1、生成要绘制的NSAttributedString对象。 ";
    
    NSAttributedString * string = [[NSAttributedString alloc]initWithString:src];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(ctx , CGAffineTransformIdentity);
    
    //CGContextSaveGState(ctx);
    
    //x，y轴方向移动
    CGContextTranslateCTM(ctx , 0 ,self.bounds.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(ctx, 1.0 ,-1.0);
    
    // layout master
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           (CFAttributedStringRef)string);
    CGMutablePathRef Path = CGPathCreateMutable();
    
    //坐标点在左下角
    CGPathAddRect(Path, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    CFArrayRef Lines = CTFrameGetLines(frame);
    
    int linecount = CFArrayGetCount(Lines);
    
    CGPoint origins[linecount];
    CTFrameGetLineOrigins(frame,
                          CFRangeMake(0, 0), origins);
    NSInteger lineIndex = 0;
    
    for (id oneLine in (__bridge NSArray *)Lines)
    {
        CGRect lineBounds = CTLineGetImageBounds((CTLineRef)oneLine, ctx);
        
        lineBounds.origin.x += origins[lineIndex].x;
        lineBounds.origin.y += origins[lineIndex].y;
        
        lineIndex++;
        //画长方形
        
        //设置颜色，仅填充4条边
        CGContextSetStrokeColorWithColor(ctx, [[UIColor redColor] CGColor]);
        //设置线宽为1
        CGContextSetLineWidth(ctx, 1.0);
        //设置长方形4个顶点
        CGPoint poins[] = {CGPointMake(lineBounds.origin.x, lineBounds.origin.y),CGPointMake(lineBounds.origin.x+lineBounds.size.width, lineBounds.origin.y),CGPointMake(lineBounds.origin.x+lineBounds.size.width, lineBounds.origin.y+lineBounds.size.height),CGPointMake(lineBounds.origin.x, lineBounds.origin.y+lineBounds.size.height)};
        CGContextAddLines(ctx,poins,4);
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }
    
    CTFrameDraw(frame,ctx);
    
    CGPathRelease(Path);
    CFRelease(framesetter);
}

#pragma mark - 图文混排

void RunDelegateDeallocCallback( void* refCon )
{
    
}

CGFloat RunDelegateGetAscentCallback(void *refCon )
{
    NSString *imageName = (__bridge NSString *)refCon;
    return 80;//[UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon)
{
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon)
{
    NSString *imageName = (__bridge NSString *)refCon;
    return 100;//[UIImage imageNamed:imageName].size.width;
}

-(void)drawCharAndPicture
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);//将当前context的坐标系进行flip
    DLog(@"bh=%f",self.bounds.size.height);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"请在这里插入一张图片位置"];
    
    //为图片设置CTRunDelegate,delegate决定留给图片的空间大小
    NSString *imgName = @"coretext_img";
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void * _Nullable)(imgName));
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];//空格用于给图片留位置
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    
    [imageAttributedString addAttribute:@"imageName" value:imgName range:NSMakeRange(0, 1)];
    
    [attributedString insertAttributedString:imageAttributedString atIndex:4];
     
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    CTParagraphStyleSetting settings[] = {
        lineBreakMode
    };
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    // set attributes to attributed string
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(ctFrame, context);
    
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), lineOrigins);
    DLog(@"line count = %ld",CFArrayGetCount(lines));
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        DLog(@"ascent = %f,descent = %f,leading = %f",lineAscent,lineDescent,lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        DLog(@"run count = %ld",CFArrayGetCount(runs));
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            DLog(@"width = %f",runRect.size.width);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = image.size;
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y;
                    CGContextDrawImage(context, imageDrawRect, image.CGImage);
                }
            }
        }
    }
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(ctFramesetter);
}



@end
