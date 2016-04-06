/*
 * Copyright (c) 2012 Mario Negro Martín
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 */

@class MNMBottomPullToRefreshView;
@class MNMBottomPullToRefreshManager;

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "CoreGraphics/CoreGraphics.h"


/**
 * Delegate protocol to implement by MNMBottomPullToRefreshManager observers to track and manage pull-to-refresh view behavior.
 */
@protocol MNMBottomPullToRefreshManagerClient


- (void)scrollViewDidScroll:(UIScrollView *)scrollView;


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/**
 * Tells client that refresh has been triggered.
 *
 * After reload is completed call [MNMBottomPullToRefreshManager tableViewReloadFinished] to get back the view to Idle state
 *
 * @param manager The pull to refresh manager.
 */
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager;

@end

#pragma mark -

/**
 * Manager that plays Mediator role and manages relationship between pull-to-refresh view and its associated table. 
 */
@interface MNMBottomPullToRefreshManager : NSObject


- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UITableView *)table withClient:(id<MNMBottomPullToRefreshManagerClient>)client;

/**
 * Relocate pull-to-refresh view at the bottom of the table taking into account the frame and the content offset.
 */
- (void)relocatePullToRefreshView;

/**
 * Sets the pull-to-refresh view visible or not. Visible by default.
 *
 * @param visible YES to make visible.
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible;

/**
 * Has to be called when the table is being scrolled. Checks the state of control depending on the offset of the table.
 */
- (void)tableViewScrolled;

/**
 * Has to be called when table dragging ends. Checks the triggering of the refresh.
 */
- (void)tableViewReleased;

/**
 * Indicates that the reload of the table is completed. Resets the state of the view to Idle.
 */
- (void)tableViewReloadFinished;

@end
