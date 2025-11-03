#import "ObjCExampleViewController.h"
@import DoximityDialerSDK;

@interface ObjCExampleViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *doximityIconImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UIButton *prefillButton;
@property (nonatomic, strong) UIButton *voiceCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;
@property (nonatomic, strong) UIButton *installDoximityButton;
@property (nonatomic, strong) UILabel *instructionsLabel;

@end

@implementation ObjCExampleViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupActions];
    [self loadDoximityIcon];
    [self updateUIForInstallationStatus];
    [self setupNotificationObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUIForInstallationStatus];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup

- (void)setupUI {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = @"Objective-C Example";

    // Initialize views
    [self initializeViews];

    // Add hierarchy
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];

    [self.contentView addSubview:self.doximityIconImageView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.phoneNumberTextField];
    [self.contentView addSubview:self.prefillButton];
    [self.contentView addSubview:self.voiceCallButton];
    [self.contentView addSubview:self.videoCallButton];
    [self.contentView addSubview:self.installDoximityButton];
    [self.contentView addSubview:self.instructionsLabel];

    // Layout
    [self setupConstraints];
}

- (void)initializeViews {
    // ScrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    // ContentView
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

    // Icon ImageView
    self.doximityIconImageView = [[UIImageView alloc] init];
    self.doximityIconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.doximityIconImageView.translatesAutoresizingMaskIntoConstraints = NO;

    // Status Label
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // Phone Number TextField
    self.phoneNumberTextField = [[UITextField alloc] init];
    self.phoneNumberTextField.placeholder = @"Enter phone number";
    self.phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNumberTextField.text = @"";
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:16];
    self.phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = NO;

    // Prefill Button
    self.prefillButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.prefillButton setTitle:@"Call with Doximity (Prefill)" forState:UIControlStateNormal];
    self.prefillButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.prefillButton.backgroundColor = UIColor.systemBlueColor;
    [self.prefillButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.prefillButton.layer.cornerRadius = 12;
    self.prefillButton.translatesAutoresizingMaskIntoConstraints = NO;

    // Voice Call Button
    self.voiceCallButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.voiceCallButton setTitle:@"Start Voice Call" forState:UIControlStateNormal];
    self.voiceCallButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.voiceCallButton.backgroundColor = UIColor.systemGreenColor;
    [self.voiceCallButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.voiceCallButton.layer.cornerRadius = 12;
    self.voiceCallButton.translatesAutoresizingMaskIntoConstraints = NO;

    // Video Call Button
    self.videoCallButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.videoCallButton setTitle:@"Start Video Call" forState:UIControlStateNormal];
    self.videoCallButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.videoCallButton.backgroundColor = UIColor.systemPurpleColor;
    [self.videoCallButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.videoCallButton.layer.cornerRadius = 12;
    self.videoCallButton.translatesAutoresizingMaskIntoConstraints = NO;

    // Install Button
    self.installDoximityButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.installDoximityButton setTitle:@"Install Doximity" forState:UIControlStateNormal];
    self.installDoximityButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.installDoximityButton.backgroundColor = UIColor.systemOrangeColor;
    [self.installDoximityButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.installDoximityButton.layer.cornerRadius = 12;
    self.installDoximityButton.translatesAutoresizingMaskIntoConstraints = NO;

    // Instructions Label
    self.instructionsLabel = [[UILabel alloc] init];
    self.instructionsLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionsLabel.numberOfLines = 0;
    self.instructionsLabel.font = [UIFont systemFontOfSize:12];
    self.instructionsLabel.textColor = UIColor.secondaryLabelColor;
    self.instructionsLabel.text = @"This example demonstrates the DoximityDialerSDK in Objective-C.\n\nPrefill: Opens Doximity with the number, letting the user choose call type.\nVoice/Video: Automatically starts the selected call type.\n\nPhone numbers can be formatted any way:\n• 5551234567\n• (555) 123-4567\n• +1 (555) 123-4567";
    self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // ScrollView
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        // ContentView
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],

        // Icon
        [self.doximityIconImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:40],
        [self.doximityIconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.doximityIconImageView.widthAnchor constraintEqualToConstant:80],
        [self.doximityIconImageView.heightAnchor constraintEqualToConstant:80],

        // Status
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.doximityIconImageView.bottomAnchor constant:20],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],

        // Phone Number
        [self.phoneNumberTextField.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:40],
        [self.phoneNumberTextField.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.phoneNumberTextField.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.phoneNumberTextField.heightAnchor constraintEqualToConstant:50],

        // Prefill Button
        [self.prefillButton.topAnchor constraintEqualToAnchor:self.phoneNumberTextField.bottomAnchor constant:24],
        [self.prefillButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.prefillButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.prefillButton.heightAnchor constraintEqualToConstant:56],

        // Voice Call Button
        [self.voiceCallButton.topAnchor constraintEqualToAnchor:self.prefillButton.bottomAnchor constant:12],
        [self.voiceCallButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.voiceCallButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.voiceCallButton.heightAnchor constraintEqualToConstant:56],

        // Video Call Button
        [self.videoCallButton.topAnchor constraintEqualToAnchor:self.voiceCallButton.bottomAnchor constant:12],
        [self.videoCallButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.videoCallButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.videoCallButton.heightAnchor constraintEqualToConstant:56],

        // Install Button
        [self.installDoximityButton.topAnchor constraintEqualToAnchor:self.videoCallButton.bottomAnchor constant:12],
        [self.installDoximityButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.installDoximityButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.installDoximityButton.heightAnchor constraintEqualToConstant:56],

        // Instructions
        [self.instructionsLabel.topAnchor constraintEqualToAnchor:self.installDoximityButton.bottomAnchor constant:40],
        [self.instructionsLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.instructionsLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.instructionsLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-40],
    ]];
}

- (void)setupActions {
    [self.prefillButton addTarget:self action:@selector(didTapPrefillButton) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceCallButton addTarget:self action:@selector(didTapVoiceCallButton) forControlEvents:UIControlEventTouchUpInside];
    [self.videoCallButton addTarget:self action:@selector(didTapVideoCallButton) forControlEvents:UIControlEventTouchUpInside];
    [self.installDoximityButton addTarget:self action:@selector(didTapInstallButton) forControlEvents:UIControlEventTouchUpInside];

    // Dismiss keyboard when tapping outside
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)setupNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

#pragma mark - Doximity Icon

- (void)loadDoximityIcon {
    NSError *error = nil;
    UIImage *icon = [DoximityDialer doximityIconAndReturnError:&error];
    if (error) {
        NSLog(@"Failed to load Doximity icon: %@", error);
        self.doximityIconImageView.hidden = YES;
    } else {
        self.doximityIconImageView.image = icon;
    }
}

#pragma mark - Installation Status

- (void)updateUIForInstallationStatus {
    BOOL isInstalled = [DoximityDialer isDoximityInstalled];

    // Update button states
    self.prefillButton.enabled = isInstalled;
    self.voiceCallButton.enabled = isInstalled;
    self.videoCallButton.enabled = isInstalled;
    self.installDoximityButton.hidden = isInstalled;

    // Update button appearance for disabled state
    CGFloat alpha = isInstalled ? 1.0 : 0.5;
    self.prefillButton.alpha = alpha;
    self.voiceCallButton.alpha = alpha;
    self.videoCallButton.alpha = alpha;

    // Update status label
    if (isInstalled) {
        self.statusLabel.text = @"✓ Doximity is installed";
        self.statusLabel.textColor = UIColor.systemGreenColor;
    } else {
        self.statusLabel.text = @"Doximity is not installed\nInstall it to make calls";
        self.statusLabel.textColor = UIColor.systemRedColor;
    }
}

- (void)handleAppDidBecomeActive {
    [self updateUIForInstallationStatus];
}

#pragma mark - Actions

- (void)didTapPrefillButton {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if (!phoneNumber || phoneNumber.length == 0) {
        [self showAlertWithTitle:@"Error" message:@"Please enter a phone number"];
        return;
    }

    // Prefill the number in Doximity Dialer
    // This lets the user choose whether to start a voice or video call
    [DoximityDialer dialPhoneNumber:phoneNumber];
}

- (void)didTapVoiceCallButton {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if (!phoneNumber || phoneNumber.length == 0) {
        [self showAlertWithTitle:@"Error" message:@"Please enter a phone number"];
        return;
    }

    // Automatically start a voice call
    [DoximityDialer startVoiceCall:phoneNumber];
}

- (void)didTapVideoCallButton {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if (!phoneNumber || phoneNumber.length == 0) {
        [self showAlertWithTitle:@"Error" message:@"Please enter a phone number"];
        return;
    }

    // Automatically start a video call
    [DoximityDialer startVideoCall:phoneNumber];
}

- (void)didTapInstallButton {
    // When Doximity is not installed, any dial method redirects to the App Store
    // We can use any method to trigger the installation flow
    [DoximityDialer dialPhoneNumber:@""];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Helper

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
