

#import <UIKit/UIKit.h>
typedef enum {
    HMDVerticalWaterFlow = 0, /** 竖向瀑布流 item等宽不等高 */
    HMDHorizontalWaterFlow = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    HMDVHWaterFlow = 2,  /** 竖向瀑布流 item等高不等宽 */
} HMDFlowLayoutStyle; //样式
@class HMDWaterflowLayout;

@protocol HMDWaterflowLayoutDelegate <NSObject>
@optional
/** 竖向瀑布流 item等宽不等高 */
-(CGFloat)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

/** 水平瀑布流 item等高不等宽 */
-(CGFloat)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight;

/** 竖向瀑布流 item等高不等宽 列数、行数无用*/
- (CGSize)waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

//以下都有默认值
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout;
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout;

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout;
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(HMDWaterflowLayout *)waterFlowLayout;
@end

@interface HMDWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<HMDWaterflowLayoutDelegate> delegate;
/** 瀑布流样式*/
@property (nonatomic, assign) HMDFlowLayoutStyle  flowLayoutStyle;
@end
