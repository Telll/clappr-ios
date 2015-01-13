//
//  MediaControlTests.m
//  Clappr
//
//  Created by Gustavo Barbosa on 12/18/14.
//  Copyright (c) 2014 globo.com. All rights reserved.
//

#import <Clappr/Clappr.h>
#import <objc/runtime.h>

SPEC_BEGIN(MediaControl)

describe(@"Media Control", ^{

    __block CLPMediaControl *mediaControl;
    __block CLPContainer *container;
    __block CLPPlayback *playback;

    NSURL *sourceURL = [NSURL URLWithString:@"http://globo.com/video.mp4"];

    beforeEach(^{
        playback = [[CLPPlayback alloc] initWithURL:sourceURL];
        container = [[CLPContainer alloc] initWithPlayback:playback];
        mediaControl = [[CLPMediaControl alloc] initWithContainer:container];
    });

    describe(@"Volume", ^{

        it(@"should have a slider to control itself", ^{
            UISlider *volumeSlider = mediaControl.volumeSlider;
            [[volumeSlider.superview should] equal:container.view];
        });

        it(@"slider should change playback's volume", ^{
            mediaControl.volumeSlider.value = 0.5f;
            [mediaControl.volumeSlider sendActionsForControlEvents:UIControlEventValueChanged];
            [[theValue(playback.volume) should] equal:theValue(0.5f)];
        });

        it(@"should have a min value of 0", ^{
            mediaControl.volumeSlider.value = -1.0f;
            [[theValue(mediaControl.volumeSlider.value) should] equal:theValue(0.0f)];
        });

        it(@"should have a max value of 1", ^{
            mediaControl.volumeSlider.value = 1.1f;
            [[theValue(mediaControl.volumeSlider.value) should] equal:theValue(1.0f)];
        });
    });

    describe(@"Play", ^{

        it(@"should contain a play/pause button embed in its container view", ^{
            UIButton *playPauseButton = mediaControl.playPauseButton;
            [[playPauseButton.superview should] equal:container.view];
        });

        it(@"should be triggered after touch the button when it is not playing", ^{

            [container stub:@selector(isPlaying) andReturn:theValue(NO)];

            [[mediaControl should] receive:@selector(play)];

            [mediaControl.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        it(@"should call container play after its play method has been called", ^{

            [container stub:@selector(isPlaying) andReturn:theValue(NO)];

            [[container should] receive:@selector(play)];

            [mediaControl.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        it(@"should trigger playing event", ^{

            [container stub:@selector(isPlaying) andReturn:theValue(NO)];

            __block BOOL callbackWasCalled = NO;
            [mediaControl once:CLPMediaControlEventPlaying callback:^(NSDictionary *userInfo) {
                callbackWasCalled = YES;
            }];

            [mediaControl.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];

            [[theValue(callbackWasCalled) should] beTrue];
        });
    });

    describe(@"Pause", ^{

        it(@"should be triggered after touch the button when it is playing", ^{

            [container stub:@selector(isPlaying) andReturn:theValue(YES)];

            [[mediaControl should] receive:@selector(pause)];

            [mediaControl.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        it(@"should call container pause after its pause method has been called", ^{

            [container stub:@selector(isPlaying) andReturn:theValue(YES)];

            [[container should] receive:@selector(pause)];

            [mediaControl.playPauseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
    });

    describe(@"Stop", ^{

        it(@"button should be embed in its container view", ^{
            UIButton *stopButton = mediaControl.stopButton;
            [[stopButton.superview should] equal:container.view];
        });

        it(@"should be called after touch the button", ^{
            [[mediaControl should] receive:@selector(stop)];
            [mediaControl.stopButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        it(@"should call container stop method", ^{
            [playback stub:@selector(isPlaying) andReturn:theValue(YES)];
            [[container should] receive:@selector(stop)];
            [mediaControl.stopButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });

        it(@"should trigger 'not playing' event", ^{

            [playback stub:@selector(isPlaying) andReturn:theValue(YES)];

            __block BOOL eventWasTriggered = NO;
            [mediaControl once:CLPMediaControlEventNotPlaying callback:^(NSDictionary *userInfo) {
                eventWasTriggered = YES;
            }];

            [mediaControl.stopButton sendActionsForControlEvents:UIControlEventTouchUpInside];

            [[theValue(eventWasTriggered) should] beTrue];
        });

        it(@"should not trigger 'not playing' event if it was already not playing", ^{

            [playback stub:@selector(isPlaying) andReturn:theValue(NO)];

            __block BOOL eventWasTriggered = NO;
            [mediaControl once:CLPMediaControlEventNotPlaying callback:^(NSDictionary *userInfo) {
                eventWasTriggered = YES;
            }];

            [mediaControl.stopButton sendActionsForControlEvents:UIControlEventTouchUpInside];

            [[theValue(eventWasTriggered) should] beFalse];

        });
    });

    describe(@"Event listening", ^{

        it(@"should toggle play after listen to container's play event", ^{
            // change the view
        });

        it(@"should trigger media control's playing event after listen to container's play event", ^{

            __block BOOL callbackWasCalled = NO;
            [mediaControl once:CLPMediaControlEventPlaying callback:^(NSDictionary *userInfo) {
                callbackWasCalled = YES;
            }];

            [container trigger:CLPContainerEventPlay];

            [[theValue(callbackWasCalled) should] beTrue];
        });

        it(@"should trigger media control's not playing event after listen to container's pause event", ^{

            __block BOOL callbackWasCalled = NO;
            [mediaControl once:CLPMediaControlEventNotPlaying callback:^(NSDictionary *userInfo) {
                callbackWasCalled = YES;
            }];

            [container trigger:CLPContainerEventPause];

            [[theValue(callbackWasCalled) should] beTrue];
        });

        it(@"should update seek bar after listen to container's time update event", ^{

        });

        it(@"should update progress bar after listen to container's progress event", ^{

        });

        it(@"should handle container's settings update event properly", ^{

        });

        it(@"should handle container's DVR state event properly ", ^{

        });

        it(@"should handle container's HD update properly", ^{

        });

        it(@"should disable after listen to container's media control disable event", ^{

        });

        it(@"should enable after listen to container's media control enable event", ^{

        });

        it(@"should handle container's ended event properly", ^{

        });
    });
});

SPEC_END