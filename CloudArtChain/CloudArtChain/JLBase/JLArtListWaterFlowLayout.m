//
//  JLArtListWaterFlowLayout.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/13.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLArtListWaterFlowLayout.h"

@interface JLArtListWaterFlowLayout ()

@property (nonatomic, strong) NSMutableArray *attrArray;
@property (nonatomic, strong) NSMutableArray *frameYa;

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;

@end

@implementation JLArtListWaterFlowLayout

+ (instancetype)layoutWithColoumn:(int)coloumn data:(NSMutableArray *)dataA verticleMin:(float)minv horizonMin:(float)minh leftMargin:(float)leftMargin rightMargin:(float)rightMargin isAuction: (BOOL)isAuction {
    JLArtListWaterFlowLayout *layout = [[JLArtListWaterFlowLayout alloc] init];
    layout.iconArray = dataA;
    layout.minimumLineSpacing = minv;
    layout.minimumInteritemSpacing = minh;
    layout.leftMargin = leftMargin;
    layout.rightMargin = rightMargin;
    layout.colunms = coloumn;
    layout.isAuction = isAuction;
    return layout;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attrArray removeAllObjects];
    //计算每个cell的宽度
    self.minimumLineSpacing = 14.0f;
    self.minimumInteritemSpacing = 14.0f;
    self.sectionInset = UIEdgeInsetsMake(13.0f, 15.0f, 0, 15.0f);
    float itemW = (self.collectionView.bounds.size.width - self.leftMargin - self.rightMargin - (self.colunms - 1) * self.minimumInteritemSpacing) / self.colunms;
    
    for (int i = 0; i < self.colunms; i++) {
        self.frameYa[i] = @(self.sectionInset.top);
    }
 
    //遍历数组m，创建数组那么多的UICollectionViewLayoutAttributes
    for(int i = 0; i < self.iconArray.count; i++) {
        Model_art_Detail_Data *iconModel = nil;
        if (self.isAuction) {
            iconModel = ((Model_auctions_Data *)self.iconArray[i]).art;
        }else {
            iconModel = self.iconArray[i];
        }
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        [self.attrArray addObject:attributes];
        //计算每个cell的高度
        float itemH = [self getcellHWithOriginSize:CGSizeMake(itemW, 110.0f + iconModel.imgHeight) itemW:itemW];
        //计算当前cell处于第几列
        int lie = [self getMinLie:self.frameYa];
        float itemX = self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * (lie);
        float itemY = [self.frameYa[lie] floatValue];
        float result  = (itemH + self.minimumLineSpacing) + [self.frameYa[lie] floatValue];
        self.frameYa[lie] = @(result);
        attributes.frame = CGRectMake(itemX, itemY, itemW, itemH);
    }
}

//计算没行中每个cell的最大Y值
- (int)getMinLie:(NSMutableArray *)frameYa {
    int col = 0;
    float min = [frameYa[col] floatValue];
    for (int i = 1; i < self.colunms; i++) {
        if(min>[frameYa[i] floatValue]){
            min = [frameYa[i] floatValue];
            col = i;
        }
    }
    return col;
}

//计算cell的高度
- (float)getcellHWithOriginSize:(CGSize)originSize itemW:(float)itemW {
    return itemW * originSize.height / originSize.width;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrArray;
}

- (NSMutableArray *)attrArray {
    if(!_attrArray) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (CGSize)collectionViewContentSize {
    int maxindex = 0;
    float max = [self.frameYa[maxindex] floatValue];
    for (int i = 1; i < self.colunms; i++) {
        if([self.frameYa[i] floatValue] > max) {
            max = [self.frameYa[i] floatValue];
            maxindex = i;
        }
    }
    return CGSizeMake(0, max);
}

- (NSMutableArray *)frameYa {
    if(!_frameYa){
        _frameYa = [NSMutableArray array];
    }
    return _frameYa;
}

@end
