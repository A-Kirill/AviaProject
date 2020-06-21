//
//  CollectionViewController.m
//  AviaProject
//
//  Created by Kirill Anisimov on 21.06.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

#import "CollectionViewController.h"
#import "ImageCollectionCell.h"

#define ImageCellReuseIdentifier @"ImageCellIdentifier"

@interface CollectionViewController ()

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation CollectionViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _images = [[NSMutableArray alloc] init];

    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(presentPickerController)];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    
    layout.itemSize = CGSizeMake(200.0, 200.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;

    [_collectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:ImageCellReuseIdentifier];
    
    [self.view addSubview:_collectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.images count] > 0) {
        NSLog(@"return %lu items for collection view", (unsigned long)[self.images count]);
        return [self.images count];
    } else {
        NSLog(@"returned 0 items for collection view");
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ImageCollectionCell alloc] init];
    }
    cell.myImage.image = [_images objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - UIImagePickerController

- (void)presentPickerController {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.delegate = self;
        
        [self presentViewController:pickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *imagePicked = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (imagePicked) {
        NSLog(@"Получено изображение");
        [_images addObject: imagePicked];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
