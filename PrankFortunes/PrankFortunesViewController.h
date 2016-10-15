//
//  PrankFortunesViewController.h
//  PrankFortunes
//
//  Created by admin on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface PrankFortunesViewController : UIViewController <UITextViewDelegate,AVAudioPlayerDelegate> {
    int h; //screen height
	int w; //screen width
    BOOL hasSmallScreen;
    int cookieH; //dimensions for the cookie message
    int cookieW;
    int cookieY;
    int cookieX;
    int bW; //button width
    int bW2; //button width for smaller buttons
    float bO; //button opacity
    NSString *prefix; //prefix for images to get ones meant for device resolution
    CGRect rectFull; //Bounds of screen
    CGRect rectL; //Message location when OFF screen
    CGRect rectR; //Message location when ON screen
    UIView *vCookie;
    UIView *vMenu;
    UIView *vMisfortune;
    UIView *vPrank;
    UIImageView *cookieOverlay;
    UITextView *cookieText;
    UIImageView *paper;
    UIButton *bHome;
    UIButton *bNext;
    UIButton *bPrev;
    UIButton *bFortune;
    UIButton *bMisfortune;
    UIButton *bPrank;
    UIButton *bMusic;
    UILabel *lFortune;
    UILabel *lMisfortune;
    UILabel *lPrank;


    int mode; //0 = fortunes, 1 = misfortunes, 2 = prank
    int frequency; //how frequently to display the misfortune/prank
    int histI; //history index
    int numFortunes;
    int numMisfortunes;
    NSMutableArray *fortunes; //Good Fortunes
    NSMutableArray *misfortunes; //Good Fortunes
    NSMutableArray *history; //Fortunes we've seen this go around

    UILabel *mTitle;
    UILabel *mFrequency;
    NSMutableArray *mOpts;
    UIButton *mContinue;
    UIButton *mHome;
    UIButton *mMinus;
    UIButton *mPlus;

    UILabel *pTitle1;
    UILabel *pTitle2;
    UILabel *pFrequency;
    NSMutableArray *pOpts;
    UITextView *pText;
    UIButton *pContinue;
    UIButton *pHome;
    UIButton *pMinus;
    UIButton *pPlus;
}

@property (retain) NSString *prefix;
@property (retain) UIView *vCookie;
@property (retain) UIView *vMenu;
@property (retain) UIView *vMisfortune;
@property (retain) UIView *vPrank;
@property (retain) UIImageView *cookieOverlay;
@property (retain) UIImageView *paper;
@property (retain) UITextView *cookieText;
@property (retain) UIButton *bHome;
@property (retain) UIButton *bNext;
@property (retain) UIButton *bPrev;
@property (retain) UIButton *bFortune;
@property (retain) UIButton *bMisfortune;
@property (retain) UIButton *bPrank;
@property (retain) UIButton *bMusic;
@property (retain) UIButton *mContinue;
@property (retain) UIButton *mHome;
@property (retain) UIButton *mMinus;
@property (retain) UIButton *mPlus;
@property (retain) UIButton *pContinue;
@property (retain) UIButton *pHome;
@property (retain) UIButton *pMinus;
@property (retain) UIButton *pPlus;
@property (retain) NSMutableArray *fortunes;
@property (retain) NSMutableArray *misfortunes;
@property (retain) NSMutableArray *history;
@property (retain) NSMutableArray *mOpts;
@property (retain) NSMutableArray *pOpts;
@property (retain) UILabel *lFortune;
@property (retain) UILabel *lMisfortune;
@property (retain) UILabel *lPrank;
@property (retain) UILabel *mFrequency;
@property (retain) UILabel *mTitle;
@property (retain) UILabel *pFrequency;
@property (retain) UILabel *pTitle1;
@property (retain) UILabel *pTitle2;
@property (retain) UITextView *pText;

-(UIButton *)makeButton:(NSString *)file action:(SEL)act bounds:(CGRect)rect;
-(UILabel *)makeLabel:(NSString *)text fontSize:(int)fontSize bounds:(CGRect)rect;
-(UITextView *)makeText:(NSString *)text fontSize:(int)fontSize bounds:(CGRect)rect;
-(UIView *)makeView:(NSString *)image;

-(void)parseFortunes;
-(void)guiSetup;
-(void)guiMenu;
-(void)guiCookie;
-(void)guiMisfortune;
-(void)guiPrank;

-(void)doHome;
-(void)doGoodFortunes;
-(void)doFortunes;
-(void)doMisfortunes;
-(void)doPrank;

-(void)mChangeMinus;
-(void)mChangePlus;
-(void)mChange:(int)delta;
-(void)pChangeMinus;
-(void)pChangePlus;
-(void)pChange:(int)delta;

-(void)resetCookie;
-(void)hideIcons;
-(void)showIcons:(NSString*)animationID finished:(BOOL)finished context:(void *)context;
-(void)showMessage:(NSString*)animationID finished:(BOOL)finished context:(void *)context;
-(void)setMessage;
-(void)prevMessage;
-(void)nextMessage;

@end
