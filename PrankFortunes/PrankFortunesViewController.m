//PrankFortunesViewController.m
//Created by Rob Bates on 11/11/10.
//Copyright 2010 ZebraStrut. All rights reserved.

#import "PrankFortunesViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PrankFortunesViewController
@synthesize prefix;
@synthesize vMenu, vCookie, vMisfortune, vPrank;
@synthesize cookieOverlay, paper, cookieText, mFrequency, mTitle, pFrequency, pTitle1, pTitle2, pText;
@synthesize fortunes, misfortunes, history, mOpts,pOpts;
@synthesize lFortune,lMisfortune,lPrank;
@synthesize bFortune,bHome,bNext,bPrev, bMisfortune,mHome,mContinue,mMinus,mPlus, bPrank,pHome,pContinue,pMinus,pPlus, bMusic;

-(void)doHome{
    histI = -1;
    [history removeAllObjects];

	[UIView beginAnimations:@"doHome" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(resetCookie)];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[vMisfortune removeFromSuperview];
	[vPrank removeFromSuperview];
	[vCookie removeFromSuperview];
    [self hideIcons];
	[UIView commitAnimations];
}
-(void)resetCookie{
    cookieText.text = @"";
    cookieText.frame = rectL;
}
-(void)doGoodFortunes{
    mode = 0;
    [self doFortunes];
}
-(void)doFortunes{
	[UIView beginAnimations:@"doFortunes" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(nextMessage)]; //Animate first cookie when done
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[vMisfortune removeFromSuperview];
	[vPrank removeFromSuperview];
	[self.view addSubview:vCookie];
	[UIView commitAnimations];
}
-(void)doMisfortunes{
    mode = 1;
    frequency = 2;
    mFrequency.text = [mOpts objectAtIndex:frequency - 1];
	[UIView beginAnimations:@"doMisfortunes" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[self.view addSubview:vMisfortune];
	[UIView commitAnimations];
}
-(void)doPrank{
    mode = 2;
    frequency = 5;
    pFrequency.text = [pOpts objectAtIndex:frequency - 1];
	[UIView beginAnimations:@"doPrank" context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[self.view addSubview:vPrank];
	[UIView commitAnimations];
}
-(void)doMusic{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ccmixter.org/files/Safary/26058"]];
}


-(void)mChangeMinus{[self mChange:-1];}
-(void)mChangePlus{[self mChange:1];}
-(void)mChange:(int)delta{
    int max = [mOpts count];
    delta = delta * -1; //Plus and minus are backward of what we'd think
    frequency--; //switch to 0-based for a moment
    frequency = frequency + delta;
    if (frequency >= max)
        frequency = max - 1;
    else if (frequency < 0)
        frequency = 0;
    mFrequency.text = (NSString *)[mOpts objectAtIndex:frequency];
    frequency++; //switch back to 1-based
}
-(void)pChangeMinus{[self pChange:-1];}
-(void)pChangePlus{[self pChange:1];}
-(void)pChange:(int)delta{
    int max = [pOpts count];
    frequency--; //switch to 0-based for a moment
    frequency = frequency + delta;
    if (frequency >= max)
        frequency = max - 1;
    else if (frequency < 0)
        frequency = 0;
    pFrequency.text = (NSString *)[pOpts objectAtIndex:frequency];
    frequency++; //switch back to 1-based
}

-(void)hideIcons{
    bPrev.alpha = 0;
    bHome.alpha = 0;
    bNext.alpha = 0;
}
-(void)showIcons:(NSString*)animationID finished:(BOOL)finished context:(void *)context{
    if (histI > 0)
        bPrev.alpha = bO;
    bHome.alpha = bO;
    bNext.alpha = bO;
}
-(void)showMessage:(NSString*)animationID finished:(BOOL)finished context:(void *)context{
    cookieText.text = [history objectAtIndex:histI];
    int fontSize = 74;
    if (hasSmallScreen)
        fontSize = 54;
    float sub = 2.0f;
    cookieText.font = [UIFont systemFontOfSize:fontSize];
    
	while ([cookieText contentSize].height > cookieH) {
        fontSize = fontSize - sub;
        if (fontSize < 24)
            sub = 1.0f;
		cookieText.font = [UIFont systemFontOfSize:fontSize];
	}

	[UIView beginAnimations:@"showMessage" context:nil];
    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(showIcons:finished:context:)];
	[UIView setAnimationDuration:0.6];
	cookieText.frame = rectR;
    [self showIcons:@"" finished:YES context:nil];
	[UIView commitAnimations];
}
-(void)setMessage{
    [self hideIcons];
	[UIView beginAnimations:@"setMessage" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showMessage:finished:context:)];
	[UIView setAnimationDuration:0.6];
	cookieText.frame = rectL;
	[UIView commitAnimations];
}
-(void)prevMessage{
    if (histI > 0)
        histI--;
    [self setMessage];
}
-(void)nextMessage{
    histI++;
    if (histI >= [history count]) {
        int temp = 0;
        NSString *old = @"";
        if (histI > 0)
            old = [history objectAtIndex:histI - 1];

        if (mode == 2 && frequency == histI + 1) { //Prank
            [history addObject:pText.text];
        } else if (mode == 1 && (histI + 1) % frequency == 0) { //Misfortune
            temp = arc4random() % numMisfortunes;
            while ([old isEqualToString:[misfortunes objectAtIndex:temp]]) {
                temp = arc4random() % numMisfortunes; //Rand fortune, not identical to last
            }
            [history addObject:[misfortunes objectAtIndex:temp]];
        } else { //Fortune
            temp = arc4random() % numFortunes;
            while ([old isEqualToString:[fortunes objectAtIndex:temp]]) {
                temp = arc4random() % numFortunes; //Rand fortune, not identical to last
            }
            [history addObject:[fortunes objectAtIndex:temp]];
        }
    }
    [self setMessage];
}


/***************Interface Functions***************/
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}
-(void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Put something personal here to prank your friend"])
        textView.text = @"";
}


-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player {}
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {}

/*****************SETUP BELOW****************/
-(void)viewDidLoad{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    //Music
    NSString *mp3 = [[NSBundle mainBundle] pathForResource:@"ValihaTrance" ofType:@"mp3"];
    AVAudioPlayer *mp = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mp3] error:NULL];
    mp.delegate = self;
    [mp play];
    mp.numberOfLoops = -1;

	h = [UIScreen mainScreen].bounds.size.width;
	w = [UIScreen mainScreen].bounds.size.height;
    histI = -1;
    frequency = 1;
    bO = .85;

    [self parseFortunes];
    [self guiSetup];
}
-(void)parseFortunes{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError *fileError1;
    NSError *fileError2;
	NSString *f = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fortunes" ofType:@"txt"]
                                            encoding:NSUTF8StringEncoding
                                               error:&fileError1];
    if(f == nil) {
        NSLog(@"FORTUNE.txt Error: %@", [fileError1 localizedDescription]);
        return;
    }
	NSString *m = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"misfortunes" ofType:@"txt"]
                                            encoding:NSUTF8StringEncoding
                                               error:&fileError2];
    if(m == nil) {
        NSLog(@"MISFORTUNE.txt Error: %@", [fileError2 localizedDescription]);
        return;
    }

	fortunes = [[NSMutableArray alloc] initWithArray:[f componentsSeparatedByString:@"\n"] copyItems:YES];
	misfortunes = [[NSMutableArray alloc] initWithArray:[m componentsSeparatedByString:@"\n"] copyItems:YES];
	numFortunes = [fortunes count];
	numMisfortunes = [misfortunes count];
    history = [[NSMutableArray alloc] init];
    
	[fortunes retain];
	[misfortunes retain];
	[history retain];
    
	[pool drain];
}
-(void)guiSetup{
    hasSmallScreen = NO;
    if (w < 980)
        hasSmallScreen = YES;
    //iPad settings
    bW = 120;
    bW2 = 90;
    cookieW = w - 275;
    cookieH = 210;
    cookieY = 320;
    cookieX = 225;
    //Set prefix for Images to get ones meant for this resolution
    if (w > 1000) {
        prefix = @"L";
    } else if (w < 500) { //iPhone3 settings
        prefix = @"S";
        bW = 60;
        bW2 = 40;
        cookieW = w - 125;
        cookieH = 105;
        cookieX = 103;
        cookieY = h*3/9;
    } else { //iPhone4 settings
        prefix = @"M";
        bW = 110;
        bW2 = 80;
        cookieW = w - 125;
        cookieH = 105;
        cookieX = 212;
        cookieY = h*3/9; //Perfect for iPhone4
    }

    rectFull = CGRectMake(0,0,w,h);
    //TODO: get real rects & test on 3, 4 & iPad
    rectL = CGRectMake(0 - cookieW,cookieY,cookieW,cookieH); //Off Screen
    rectR = CGRectMake(cookieX,cookieY,cookieW,cookieH); //On Screen

    [self guiMenu];
    [self guiCookie];
    [self guiMisfortune];
    [self guiPrank];
}
-(void)guiMenu{
    int cH = 200;
    int cW = 200;
    vMenu = [self makeView:@"back.png"];
    if (hasSmallScreen) {
        if ([@"S" isEqualToString:prefix]) {
            cH = 120;
            cW = 120;
        } else {
            cH = 160;
            cW = 160;
        }
    }
    int left = w/3 - cW;
    int top = h*8/20;
    bFortune = [self makeButton:@"_c1.png" action:@selector(doGoodFortunes) bounds:CGRectMake(left,top,cW,cH)];
    lFortune = [self makeLabel:@"Normal" fontSize:50 bounds:CGRectMake(left-20,top+cH-18,cW+40,cH/3)];

    left = w*2/3;
    top = h*8/20;
    bMisfortune = [self makeButton:@"_c2.png" action:@selector(doMisfortunes) bounds:CGRectMake(left,top,cW,cH)];
    lMisfortune = [self makeLabel:@"Misfortune" fontSize:50 bounds:CGRectMake(left-20,top+cH-18,cW+40,cH/3)];

    left = w/2 - cW/2;
    top = 5;
    bPrank = [self makeButton:@"_c3.png" action:@selector(doPrank) bounds:CGRectMake(left,top,cW,cH)];
    lPrank = [self makeLabel:@"Prank" fontSize:50 bounds:CGRectMake(left-20,top+cH-18,cW+40,cH/3)];

    int imgH = 42;
    int imgW = 189;
    bMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [bMusic setImage:[UIImage imageNamed:@"music.png"] forState:UIControlStateNormal];
    [bMusic addTarget:self action:@selector(doMusic) forControlEvents:UIControlEventTouchUpInside];
    bMusic.frame = CGRectMake(w/2 - imgW/2 - 5,h - imgH, imgW,imgH);


    [vMenu addSubview:lFortune];
    [vMenu addSubview:bFortune];
    [vMenu addSubview:lMisfortune];
    [vMenu addSubview:bMisfortune];
    [vMenu addSubview:lPrank];
    [vMenu addSubview:bPrank];
    [vMenu addSubview:bMusic];
    [self.view addSubview:vMenu];

    [vMenu retain];
    [bFortune retain];
    [bMisfortune retain];
    [bPrank retain];
    [bMusic retain];
    [lFortune retain];
    [lMisfortune retain];
    [lPrank retain];
}
-(void)guiCookie{
    vCookie = [self makeView:@"cookie2.png"];
    cookieText = [self makeText:@"" fontSize:60 bounds:rectL];
    paper = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,rectL.size.width,rectL.size.height)];
    paper.image = [UIImage imageNamed:@"paper.png"];
    paper.contentMode = UIViewContentModeTopRight;//UIViewContentModeScaleAspectFill;
    [cookieText addSubview: paper];
    [cookieText sendSubviewToBack: paper];

    cookieOverlay = [[UIImageView alloc] initWithFrame:rectFull];
    cookieOverlay.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@cookie1.png", prefix]];
    cookieOverlay.contentMode = UIViewContentModeBottomLeft;
    [vCookie addSubview:cookieText];
    [vCookie addSubview:cookieOverlay];

    int pad = 3;
    bHome = [self makeButton:@"_home.png" action:@selector(doHome) bounds:CGRectMake(w/2 - bW/2,h - bW - pad,bW,bW)];
    bPrev = [self makeButton:@"_back.png" action:@selector(prevMessage) bounds:CGRectMake(w/2 - bW*2.5,h - bW - pad,bW,bW)];
    bNext = [self makeButton:@"_next.png" action:@selector(nextMessage) bounds:CGRectMake(w/2 + bW*1.5,h - bW - pad,bW,bW)];
    [self hideIcons];
    [vCookie addSubview:bHome];
    [vCookie addSubview:bPrev];
    [vCookie addSubview:bNext];
    
    [vCookie retain];
    [cookieText retain];
    [cookieOverlay retain];
    [paper retain];
    [bHome retain];
    [bPrev retain];
    [bNext retain];
}
-(void)guiMisfortune{
    int pad = 3;
    vMisfortune = [self makeView:@"back.png"];
    mHome = [self makeButton:@"_cancel.png" action:@selector(doHome) bounds:CGRectMake(w/2 - bW*2.5,h - bW - pad,bW,bW)];
    mContinue = [self makeButton:@"_check.png" action:@selector(doFortunes) bounds:CGRectMake(w/2 + bW*1.5,h - bW - pad,bW,bW)];
    pad = 227;
    if (hasSmallScreen)
        pad = 100;
    mOpts = [[NSMutableArray alloc] init];
    [mOpts addObject:@"Every Time"];
    [mOpts addObject:@"Every Other Time"];
    [mOpts addObject:@"Every 3rd Time"];
    [mOpts addObject:@"Every 4th Time"];
    [mOpts addObject:@"Every 5th Time"];
    [mOpts addObject:@"Every 6th Time"];
    [mOpts addObject:@"Every 7th Time"];
    [mOpts addObject:@"Every 8th Time"];
    [mOpts addObject:@"Every 9th Time"];
    [mOpts addObject:@"Every 10th Time"];
    [mOpts addObject:@"Every 11th Time"];
    [mOpts addObject:@"Every 12th Time"];
    [mOpts addObject:@"Every 13th Time"];
    [mOpts addObject:@"Every 14th Time"];
    [mOpts addObject:@"Every 15th Time"];
    [mOpts addObject:@"Every 16th Time"];
    [mOpts addObject:@"Every 17th Time"];
    [mOpts addObject:@"Every 18th Time"];
    [mOpts addObject:@"Every 19th Time"];
    [mOpts addObject:@"Every 20th Time"];

    int currH = h/5;
    mTitle = [self makeLabel:@"Show a Misfortune:" fontSize:50 bounds:CGRectMake(0,currH,w,bW)];
    currH = currH + bW - 10;
    mFrequency = [self makeLabel:[mOpts objectAtIndex:1] fontSize:50 bounds:CGRectMake(0,currH,w,bW)];
    currH = currH + 12;
    mMinus = [self makeButton:@"_minus.png" action:@selector(mChangeMinus) bounds:CGRectMake(pad,currH,bW2,bW2)];
    mPlus = [self makeButton:@"_plus.png" action:@selector(mChangePlus) bounds:CGRectMake(w - pad - bW2,currH,bW2,bW2)];

    [vMisfortune addSubview:mTitle];
    [vMisfortune addSubview:mFrequency];
    [vMisfortune addSubview:mMinus];
    [vMisfortune addSubview:mPlus];
    [vMisfortune addSubview:mHome];
    [vMisfortune addSubview:mContinue];

    [vMisfortune retain];
    [mTitle retain];
    [mHome retain];
    [mContinue retain];
    [mMinus retain];
    [mPlus retain];
    [mOpts retain];
    [mFrequency retain];
}
-(void)guiPrank{
    int pad = 15;
    if (hasSmallScreen)
        pad = 3;
    int currH = 0;
    int prankH = 100;
    if (hasSmallScreen)
        prankH = 65;
    vPrank = [self makeView:@"back.png"];
    pHome = [self makeButton:@"_cancel.png" action:@selector(doHome) bounds:CGRectMake(w/2 - bW*2.5,h - bW - pad,bW,bW)];
    pContinue = [self makeButton:@"_check.png" action:@selector(doFortunes) bounds:CGRectMake(w/2 + bW*1.5,h - bW - pad,bW,bW)];
    pOpts = [[NSMutableArray alloc] init];
    [pOpts addObject:@"1st Cookie"];
    [pOpts addObject:@"2nd Cookie"];
    [pOpts addObject:@"3rd Cookie"];
    [pOpts addObject:@"4th Cookie"];
    [pOpts addObject:@"5th Cookie"];
    [pOpts addObject:@"6th Cookie"];
    [pOpts addObject:@"7th Cookie"];
    [pOpts addObject:@"8th Cookie"];
    [pOpts addObject:@"9th Cookie"];
    [pOpts addObject:@"10th Cookie"];

    pad = 275;
    if (hasSmallScreen)
        pad = 115;
    pTitle1 = [self makeLabel:@"Display this Prank Message:" fontSize:50 bounds:CGRectMake(0,currH,w,bW)];
    currH = currH + bW - 10;
    pText = [[UITextView alloc] initWithFrame:CGRectMake(30,currH,w-60,prankH)];
    [pText setReturnKeyType:UIReturnKeyDone];
    pText.delegate = self;
    pText.text = @"Put something personal here to prank your friend!";
    int fontSize = 30;
    if (hasSmallScreen)
        fontSize = 22;
    pText.font = [UIFont systemFontOfSize:fontSize];

    currH = currH + prankH;
    pTitle2 = [self makeLabel:@"for the:" fontSize:50 bounds:CGRectMake(0,currH,w,bW)];
    currH = currH + bW - 25;
    pFrequency = [self makeLabel:[pOpts objectAtIndex:4] fontSize:50 bounds:CGRectMake(0,currH,w,bW)];
    pMinus = [self makeButton:@"_minus.png" action:@selector(pChangeMinus) bounds:CGRectMake(pad,currH,bW,bW)];
    pPlus = [self makeButton:@"_plus.png" action:@selector(pChangePlus) bounds:CGRectMake(w - pad - bW,currH,bW,bW)];

    [vPrank addSubview:pTitle1];
    [vPrank addSubview:pText];
    [vPrank addSubview:pTitle2];
    [vPrank addSubview:pFrequency];
    [vPrank addSubview:pMinus];
    [vPrank addSubview:pPlus];
    [vPrank addSubview:pHome];
    [vPrank addSubview:pContinue];
    
    [vPrank retain];
    [pTitle1 retain];
    [pTitle2 retain];
    [pHome retain];
    [pContinue retain];
    [pText retain];
    [pMinus retain];
    [pPlus retain];
    [pOpts retain];
    [pFrequency retain];
}

-(UIView *)makeView:(NSString *)image {
    UIView *temp = [[UIView alloc] initWithFrame:rectFull];
    temp.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", prefix, image]]];
    return temp;
}
-(UIButton *)makeButton:(NSString *)file action:(SEL)act bounds:(CGRect)rect {
    float alpha = 1;
    UIButton *but;    
    NSString *firstChar = [file substringToIndex:1];
    if ([firstChar isEqualToString:@"_"]) { //Icon Button
        alpha = bO;
        if ([@"_c1.png" isEqualToString:file] || [@"_c2.png" isEqualToString:file] || [@"_c3.png" isEqualToString:file])
            alpha = 1;
        file = [NSString stringWithFormat:@"%@%@", prefix, file];
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setImage:[UIImage imageNamed:file] forState:UIControlStateNormal];
    } else { //Text Button
        but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [but setTitle:file forState:UIControlStateNormal];
        //TODO: style text & background (or make an icon)
    }    
    [but addTarget:self action:act forControlEvents:UIControlEventTouchUpInside];
    but.alpha = alpha;
    but.frame = rect;
    return but;
}
-(UILabel *)makeLabel:(NSString *)text fontSize:(int)fontSize bounds:(CGRect)rect {
    if (hasSmallScreen) {
        if (prefix == @"S") { //iPhone < 4
            fontSize = fontSize/2; //smaller font sizes for phone
        } else { //iPhone 4 or greater
            fontSize = fontSize * 0.75; //smaller font sizes for phone4
        }
        if (fontSize < 14)
            fontSize = 14;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
	label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.contentMode = UIViewContentModeTop;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(2,2);
    label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
    label.lineBreakMode = UILineBreakModeTailTruncation;
	label.numberOfLines = 1;
    return label;
}
-(UITextView *)makeText:(NSString *)text fontSize:(int)fontSize bounds:(CGRect)rect {
    if (hasSmallScreen) {
        if (prefix == @"S") { //iPhone < 4
            fontSize = fontSize/2; //smaller font sizes for phone
        } else { //iPhone 4 or greater
            fontSize = fontSize * 0.75; //smaller font sizes for phone4
        }
        if (fontSize < 14)
            fontSize = 14;
    }
    UITextView *tv = [[UITextView alloc] initWithFrame:rect];
	tv.text = text;
    tv.backgroundColor = [UIColor clearColor];
    tv.font = [UIFont systemFontOfSize:fontSize];
    tv.textAlignment = UITextAlignmentCenter;
	tv.textColor = [UIColor darkGrayColor];
    tv.contentMode = UIViewContentModeCenter;
    tv.editable = NO;
    tv.scrollEnabled = NO;
    return tv;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}
-(void)viewDidUnload{[super viewDidUnload];}
-(void)dealloc{[super dealloc];}
-(void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}
@end