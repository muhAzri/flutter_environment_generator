# Flutter Environment Generator CLI Tool v1

![GitHub issues](https://img.shields.io/github/issues/muhAzri/flutter_environment_generator)
![GitHub pull requests](https://img.shields.io/github/issues-pr/muhAzri/flutter_environment_generator)
![GitHub contributors](https://img.shields.io/github/contributors/muhAzri/flutter_environment_generator)
![GitHub](https://img.shields.io/github/license/muhAzri/flutter_environment_generator)



## Warning

- This Package Use Dart Define Feature For Environments configuration
- This Package Flavor Launcher only Support on **Vscode IDE**

## About

The **Flutter Environment Generator CLI Tool** is a versatile utility designed to simplify and manage critical configurations within your Flutter project. It streamlines the process of modifying your app's name and bundle identifier (Bundle ID) across multiple platforms with ease.

- **Android**
- **IOS (Need Extra Config)**

## Key Features

- Generate Dart define configurations for different environments.
- Automatically set up the mobile environment for Dev, Staging, and Production.
- Seamlessly update your app's name and bundle identifier.

## Installation

To install the Rename CLI Tool, execute the following command:

```sh
flutter pub global activate flutter_environment_generator
```

### Running a Script

You can [run a script directly](https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path) using `flutter_environment_generator` from the activated package through the command line. If facing any issues, alternate commands are `dart pub global run flutter_environment_generator` or `flutter pub global run flutter_environment_generator`. For path variable issues, refer to [ensuring your path variables are set up correctly](https://dart.dev/tools/pub/glossary#system-cache).

## Usage

To utilize the **Flutter Environment Generator CLI Tool**, follow these simple steps:

1. Open your terminal or command prompt.

2. Navigate to the root directory of your Flutter project.

3. Run the following command:

    ```sh
    flutter_environment_generator start
    ```

   This command will trigger the tool and initiate the environment setup and configuration process for your project.

Now, sit back and let the **Flutter Environment Generator CLI Tool** simplify the management of your app's environment settings across various platforms with ease.

4. Run Your App On Vscode By Using Vscode Runner

![Runner](https://github.com/muhAzri/flutter_environment_generator/blob/main/screenshoots/vscode%20runner.png?raw=true)

or you can simply use this command in Terminal 

```
    // DEV
    flutter run --flavor dev --dart-define-from- env_dev.json

    // STAGING
    flutter run --flavor staging --dart-define-from- env_staging.
    
    // PRODUCTION
    flutter run --flavor prod --dart-define-from- env_prod.json
```

   

## Android App Name Configuration

At First this code will be generated at **android/app/build.gradle** once you run the **Flutter Environment Generator CLI Tool**

You Can Edit the resValue for changing the App Label

```
 flavorDimensions  'app'

    productFlavors {
        dev {
            dimension "app"
            resValue "string", "app_name", "package_test Dev" // YOU CAN EDIT THIS LINE FOR CHAGE THE APP LABEL
            versionNameSuffix "-dev"
            applicationId "com.example.package_test.dev"
        }
        staging {
            dimension "app"
            resValue "string", "app_name", "package_test Staging " // YOU CAN EDIT THIS LINE FOR CHAGE THE APP LABEL
            versionNameSuffix "-stg"
            applicationId "com.example.package_test.staging"
        }
        prod {
            dimension "app"
            resValue "string", "app_name", "package_test" // YOU CAN EDIT THIS LINE FOR CHAGE THE APP LABEL
            applicationId "com.example.package_test"
        }
    }
```

## IOS Extra Config
1. Open Your IOS Folder in XCODE

![OpenXcode](https://github.com/muhAzri/flutter_environment_generator/raw/main/screenshoots/open-xcode.png)

2. Select Scheme at First it will be only 1 Scheme Called Runner

![InitScheme](https://github.com/muhAzri/flutter_environment_generator/raw/main/screenshoots/scheme-first.png)

3. Duplicate Existing Scheme Into 3 Scheme and Rename all into like this(dev, staging, prod)

![SchemeAfter](https://github.com/muhAzri/flutter_environment_generator/raw/main/screenshoots/scheme-after.png)

4. Now Goes to Runner Projects And Info

![Project](https://github.com/muhAzri/flutter_environment_generator/blob/main/screenshoots/info-project.png?raw=true)

Then Duplicate all Configurations into 3 Config Each Like and rename it like this

 ![AfterConfig](https://github.com/muhAzri/flutter_environment_generator/raw/main/screenshoots/config-after.png)

5. Now Edit the each Scheme into Using right Configurations
Example For Staging Scheme using Debug staging, profile staging and release staging

![example-staging-scheme](https://github.com/muhAzri/flutter_environment_generator/raw/main/screenshoots/staging-example.png)

6. For Changing App Label you can go to the runner Targets, Build Settings and search for Display 

![app-label](https://github.com/muhAzri/flutter_environment_generator/raw/main/screenshoots/app-label.png)

7. You can Also Configure the App Bundle ID in the build Settings

![app-label](https://github.com/muhAzri/flutter_environment_generator/raw/main/screenshoots/bundle_id.png)

8. **Your IOS Should Be Configured And can be Builded**



## License

This project is licensed under the MIT License. Refer to the LICENSE file for details.

## Contributing

Contributions are welcome! Please refer to our contributing guidelines to get started.

## Changelog

For all notable changes to this project, refer to the CHANGELOG.

## Support

For any issues or suggestions, please open an issue. Your feedback is highly appreciated.

## Author

This project is created and maintained by [Muhammad Azri Fatihah Susanto](https://github.com/muhAzri).
[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/muhaazri)
