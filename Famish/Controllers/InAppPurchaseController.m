//
//  InAppPurchaseController.m
//  Famish
//
//  Created by Francisco Flores on 12/22/12.
//  Copyright (c) 2012 adr.enal.in Groupe. All rights reserved.
//

#import "InAppPurchaseController.h"
#import "Tapstream.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface InAppPurchaseController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation InAppPurchaseController {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    Event *e = [Event eventWithName:@"purchase" oneTimeOnly:NO];
    [[Tapstream instance] fireEvent:e];
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                             initWithTitle: @"iTunes Error"
                             message: @"Cannot connect to iTunes Store. If error persists, email holla@adr.enal.in"
                             delegate: nil
                             cancelButtonTitle: @"Okay"
                             otherButtonTitles: nil];
        
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];

        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier
{    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

@end
