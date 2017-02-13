//
//  HRVerticalArticleSection.m
//  Layout
//
//  Created by Allen on 03/02/2017.
//  Copyright © 2017 Yahoo. All rights reserved.
//

#import "HRVerticalArticleSection.h"
#import <WebKit/WebKit.h>

static NSString *css = @"a,body,font,li,li>a,p,ul,ul>li{font-family:\"Helvetica Neue\",sans-serif!important;font-size:23px!important}a:link,a:visited{text-decoration:none}iframe,img{width:100%!important}h1,h2,h3,h4,h5,h6{font-family:\"Helvetica Neue\",sans-serif!important;color:#5f5f5f!important}body{margin:0;padding:0 20px 12px}a,body,li,li>a,p,ul,ul>li{text-align:left;color:#000!important;line-height:1.5!important;word-wrap:break-word;word-break:break-word;overflow-wrap:break-word;hyphens:auto}a:link{color:#324fe1!important}a:visited{color:#1d1da3!important}img{height:auto!important;margin:10px 0}";

static NSString *html = @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> <html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"he\" lang=\"he\"><head><style type=\"text/css\" media=\"all\">%@</style><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /></head><body><div id=\"hr_wrapper\">%@</div><script type=\"text/javascript\">window.onload = function() { window.location.href=\"ready://\"+document.body.offsetHeight; }</script></body></html>";

static NSString *mockContent = @"<p>工商時報【蕭博文╱台北報導】 台北地檢署偵辦樂陞案，認定前董事長許金龍自導自演日商百尺竿頭併購案坑殺股民，私下卻靠內線交易大賺千萬，並找「國票大盜」楊博智（楊瑞仁）操縱股價，藉私募股票、可轉換公司債套取個人利益，不法獲利高達40億元，昨依證券詐欺等10罪起訴許、楊等10人；檢方怒批許犯後飾詞狡辯、毫無悔意，具體求處有期徒刑上限30年。 至於共謀併購案的百尺竿頭日籍負責人?埜由昭（KASHINO YOSHAKI）、樂陞財務顧問林宗漢、大陸世紀華通首席執行官王佶，檢方則對3人發布通緝。</p> \n<p> 在押的許金龍昨移審北院，北院下午2點半召開羈押庭，許把法庭當談話性節目，自備看板，慷慨激昂對檢方起訴罪事實逐一辯駁，否認犯罪，法官最後裁定許交保6,000萬元，另加書面保2億元。但許當庭告知法官，過年前找不到人辦書面保，也拿不出現金6,000萬元，要求繼續禁見，他說已習慣目前的環境，法官諭知暫時解送看守所。 起訴指出，許金龍為營造樂陞經營良好、外資看好等假象，去年3月起策畫併購案，5月與王佶、（木堅）?埜由昭、林宗漢於君悅飯店密會，謀定以「日資為名，陸資為實」方式，由（木堅）?埜由昭擔任百尺竿頭負責人並出資2成、王佶出資8成，公開收購樂陞股票3萬8,000股。</p> \n<p> 許金龍先是調度境外公司資金，以2.3億美元作為百尺竿頭資金證明；去年5月31日，百尺竿頭公開收購訊息，翌日樂陞股價大漲至每股114元，近2萬應賣人登記；同年8月17日，應賣數量已達門檻，許卻不支付48億6,000萬元股款，至8月30日公告收購破局，又因樂陞出售Tiny Piece公司未收足價金，股價慘跌至每股10元，投資人損失慘重。 許金龍早在去年5月16日至31日，於併購案消息未公開前，透過楊博智（原名楊瑞仁）尋找金主與人頭買賣樂陞股票，獲利1,518萬元。消息公開後，樂陞股價大漲，許再出售1,496張樂陞股票。</p> \n<p> 楊博智坦承幫許金龍操盤，但許金龍未給予酬勞，而是靠著仲介金主抽取0.05％佣金，每月近10萬元。檢方估計，楊博智經手的股票投資金額高達6億元，考量楊認罪並繳回320萬元不法所得，請求法院量處適當之刑。</p> \n<p> 檢方指出許金龍坐擁大量樂陞股票，股價一漲一跌直接影響其身價，痛批許金龍多次隱瞞樂陞董事會，運用高度財務槓桿，利用內部人身分操控發行面，結合股市作手在交易面牟圖私利，擾亂證券市長秩序，造成投資人損失達28億元。</p> \n<p><strong>相關新聞影音</strong></p> \n<iframe src=\"https://tw.news.yahoo.com/video/2-6億保金籌不出-許金龍-牢裡過年-083911170.html?format=embed&amp;region=TW&amp;lang=zh-Hant-TW&amp;site=news&amp;player_autoplay=true\" width=\"630\" height=\"354\" frameborder=\"0\" data-yom-embed-source=\"{media_id_1:7e879332-f8d3-3ac0-8c9c-33c7929783f7}\"></iframe>";

@interface HRVerticalArticleSection ()
<
    WKUIDelegate,
    WKNavigationDelegate
>

@property (nonatomic) WKWebView *webView;

@end

@implementation HRVerticalArticleSection

- (instancetype)init
{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithDataSourceItems:(NSArray *)dataSourceItems
{
    if (self = [super initWithDataSourceItems:dataSourceItems]) {
        [self setUp];
    }
    return  self;
}

- (void)setUp
{
    __weak typeof (self) weakSelf = self;
    self.registerForCellReuseIdentifierBlock = ^(UICollectionView *collectionView) {
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    };
    self.cellForItemAtIndexPathBlock = ^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        UIView *view = [cell.subviews firstObject];
        if (!view.subviews.count) {
            strongSelf.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), 2700)];
            [view addSubview:strongSelf.webView];
        } else {
            strongSelf.webView = [view.subviews firstObject];
        }
        strongSelf.webView.navigationDelegate = strongSelf;
        strongSelf.webView.UIDelegate = strongSelf;
        strongSelf.webView.scrollView.scrollEnabled = NO;
        // [strongSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
        NSString *caseHTML = [NSString stringWithFormat:html, css, mockContent];
        [strongSelf.webView loadHTMLString:caseHTML baseURL:nil];
        return cell;
    };
    self.layoutSizeForItemAtIndexPathBlock = ^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
        typeof (weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return CGSizeZero;
        }
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 2700/*CGRectGetHeight(strongSelf.webView.frame)*/);
    };
    self.sectionDidSelectItemAtIndexPathBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id dataSourceItemAtIndexPath) {
    };
}

#pragma mark <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    /*
    if ([[url scheme] isEqualToString:@"ready"]) {
        float contentHeight = [[url host] floatValue];
        CGRect fr = self.webView.frame;
        fr.size = CGSizeMake(self.webView.frame.size.width, contentHeight);
        self.webView.frame = fr;
        return NO;
    }
    */
    CGFloat estimatedHeight = [[navigationAction.request.URL.absoluteString stringByReplacingOccurrencesOfString:@"ready://" withString:@""] floatValue];
    if (estimatedHeight) {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else {
//        CGRect frame = self.webView.frame;
//        frame.size.height = estimatedHeight;
//        self.webView.frame = frame;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
