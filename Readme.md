# Tokenizer iOS SDK

## Table of Contents

#### 1. [Summary](#summary)
#### 2. [Dependencies](#dependencies)
#### 3. [Integration](#integration)
#### 4. [Before You Start](#before-you-start)
#### 5. [Reveal Data](#reveal-data)
#### 6. [Collect Data](#collect-data)
#### 7. [Demo Application](#demo-application)
#### 8. [License](#license)

## Summary

The `Tokenizer` SDK is a secure and high-performance solution for handling sensitive data through tokenization.  
It enables both **tokenization** and **detokenization** of data, ensuring that sensitive information is protected while remaining accessible for legitimate use within your applications.

In addition to its core functionality, the SDK includes secure **UI components** compatible with both **SwiftUI** and **UIKit**, designed for safe input and display of sensitive information.

## Dependencies

| Dependency        | Version |
|-------------------|---------|
| Min iOS Version   | 12      |
| Swift Version     | 5       |

## Integration

To integrate **Tokenizer** into your iOS project using Swift Package Manager:

### 1. Open your Xcode project

Go to: File → Add Packages...

### 2. Add the package URL

Paste the following URL into the search bar: https://github.com/infra-astropay/tokenizer-ios-spm

### 3. Select the version

Choose the latest version (e.g., `1.2.0`) or specify a version that suits your needs. Click **Add Package**.

### 4. Import the module

In your Swift file:

```swift
import Tokenizer
```
You're now ready to use the SDK! 🎉

## Before you start

Your organization needs to be registered with the company.

Two `access tokens` will be provided in advance. They will serve as unique identifiers to perform tokenization operations:
- **Sandbox Access Token**: Used for testing and development in the sandbox environment.
- **Production Access Token**: Used for live operations in the production environment.

## 🔓 Reveal Data

 ### Overview
- **What is TokenRevealer?**
  
  `TokenRevealer` allows you to securely manage and reveal sensitive data tokens in your UI. It facilitates controlled disclosure of sensitive data, ensuring that only authorized views have access to this information at the right time.
  
### How TokenRevealer Works

- **Subscribing Views**: Views that need to display sensitive data must subscribe with an identifier (`contentPath`).
  
- **Revealing Data**: After subscribing, the content can be revealed through the `revealSubscribedViews()` method, which securely exposes the data.

- **Unsubscribing Views**: Views can be unsubscribed individually or all at once to stop revealing data.

 ### Usage Overview

- [1. Create an Instance of TokenRevealer](#1-create-an-instance-of-tokenrevealer)
- [2. Create Secure UI Component (Reveal)](#2-create-secure-ui-component-reveal)
  - [2.1 UIKit Integration (Reveal)](#21-uikit-integration-reveal)
  - [2.2 SwiftUI Integration (Reveal)](#22-swiftui-integration-reveal)

### 1. Create an Instance of TokenRevealer

To securely display tokenized data within the UI, use the `TokenRevealer` class.

The `TokenRevealer` is responsible for **controlled disclosure** of sensitive data by securely revealing tokens within views that conform to the `SecureLabelProtocol`. These views are registered using a **content path**, and the token is revealed via the `reveal()` method.

##### 🔧 TokenRevealer Methods

| Function                                                                 | Return Type                       | Description                                                                                                                           |
| ------------------------------------------------------------------------ | --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `subscribe(view: SecureLabelProtocol, contentPath: String)`             | `Void`                            | Subscribes the view to be revealed, with `contentPath` serving as an identifier for the content to be revealed.                       |
| `unsubscribe(contentPath: String)`                                      | `Void`                            | Removes the view associated with `contentPath` from the list of subscribed views, stopping it from revealing further content.        |
| `unsubscribeAllViews()`                                                 | `Void`                            | Unsubscribes all views that are currently subscribed, effectively stopping the revealing process for all views.                      |
| `revealSubscribedViews(completion: @escaping (Result<Void, RevealTokenError>) -> Void)` | `Void`             | Reveals the content of all subscribed views. Upon completion, the result is returned in the completion handler.                      |                                                  |

### Usage Steps

1. **Create an instance of TokenRevealer**:
    ```swift
    private var tokenRevealer: TokenRevealerProtocol = TokenRevealer()
    ```

2. **Register views for revealing**:
    Use `subscribe(view:contentPath:)` to register each `SecureLabelProtocol` view with its corresponding content identifier.

3. **Reveal the content**:
    When ready to reveal the tokenized content, call `revealSubscribedViews()`.

4. **Stop revealing content**:
    - Use `unsubscribe(contentPath:)` to remove a specific view.
    - Use `unsubscribeAllViews()` to remove all views at once.

### 2. Create Secure UI Component (Reveal)

##### `SecureLabelProtocol`

Defines a protocol for secure labels that display sensitive data securely, with options to customize the appearance and behavior through a view model. The label is designed to handle and reveal tokenized data while ensuring security and privacy.

##### 📘 SecureLabelProtocol Properties & Methods:

| Property/Function                   | Type                             | Description                                                                                         |
| ----------------------------------- | -------------------------------- | --------------------------------------------------------------------------------------------------- |
| `token`                             | `String`                         | Holds the secure token associated with the label. This is the data that will be revealed or hidden.  |
| `viewModel`                         | `SecureLabelViewModel`           | Provides the view model that configures the appearance and behavior of the secure label.            |
| `setToken(_ newToken: String)`      | `Void`                           | Assigns a new token to the label. Used to update the tokenized data that the label will display.    |
| `hideData()`                        | `Void`                           | Hides the displayed data, keeping the token secure.                                                 |
| `copyText(withFormat: Bool)`        | `Void`                           | Copies the tokenized data to the clipboard. If `withFormat` is true, uses the formatting in `viewModel`. |


#### 2.1 UIKit Integration (Reveal)

UI component conforming to `SecureLabelProtocol`, created using `ComponentBuilder` via the `createSecureLabel` function.

This function initializes a `SecureLabelProtocol` component with customizable behavior, allowing you to configure token handling, copying functionality, and secure data revealing.

```swift
private lazy var cardValueLabel: SecureLabelProtocol = {
    let label = ComponentBuilder.createSecureLabel(
        token: "tok_test_123",
        viewModel: SecureLabelViewModel(
            textColor: .black,
            font: UIFont(name: "Helvetica-Bold", size: 18),
            placeholder: "**** **** **** ****",
            contentPath: "card.number",
            regexPattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})",
            regexTemplate: "$1 $2 $3 $4"),
        tokenRevealer: tokenRevealer)
    return label
}()
```
##### 📘 createSecureLabel Function Parameters


| Property            | Type                    | Description                                                                                           |
| ------------------- | ----------------------- | ----------------------------------------------------------------------------------------------------- |
| `token`             | `String`                | The tokenized data that the label will display securely. This is the sensitive information to be revealed or hidden. |
| `viewModel`         | `SecureLabelViewModel`  | The view model that configures the appearance and behavior of the secure label.                        |
| `copied`            | `(() -> Void)?`         | A closure triggered when the tokenized data is copied to the clipboard. This allows handling additional logic after the copy action. |
| `tokenRevealer`     | `TokenRevealerProtocol` | The token revealer responsible for securely revealing the tokenized data. It manages the secure handling and display of sensitive information. |

#### 2.2 SwiftUI Integration (Reveal)

A SwiftUI-compatible wrapper around SecureLabel, built using UIViewRepresentable. It securely displays sensitive tokenized data and allows customization of its behavior and appearance. The view automatically registers itself with the provided TokenRevealerProtocol using the contentPath defined in the viewModel.

##### 📘 SecureLabelSwiftUI Properties:

| Property         | Type                    | Default | Description                                                                        |
| ---------------- | ----------------------- | ------- | ---------------------------------------------------------------------------------- |
| `token`          | `String`                | –       | The tokenized data to be displayed securely.                                       |
| `viewModel`      | `SecureLabelViewModel`  | –       | Configures the appearance and formatting of the label (e.g. colors, fonts, regex). |
| `shouldHideData` | `Bool`                  | `false` | Whether the token should be initially hidden.                                      |
| `shouldCopyText` | `Bool`                  | `false` | Enables copying the tokenized data to the clipboard.                               |
| `copyWithFormat` | `Bool`                  | `false` | Copies the formatted version of the token (if formatting is defined).              |
| `copied`         | `(() -> Void)?`         | `nil`   | Closure called after the copy action completes.                                    |
| `tokenRevealer`  | `TokenRevealerProtocol` | –       | Handles secure revealing of tokenized data by `contentPath`.                       |

```swift
SecureLabelSwiftUI(
    token: "tok_test_123",
    viewModel: SecureLabelViewModel(
        textColor: .black,
        font: UIFont(name: "Helvetica-Bold", size: 18),
        placeholder: "**** **** **** ****",
        contentPath: "card.number",
        regexPattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})",
        regexTemplate: "$1 $2 $3 $4"),
    tokenRevealer: tokenRevealer)
```

## 🔒 Collect Data

### Overview

- **What is TokenCollector?**

  `TokenCollector` allows you to securely gather and manage sensitive user input from your UI. It enables controlled collection and optional tokenization of data entered in views, ensuring that only subscribed and authorized fields are included when collecting information.


### How TokenCollector Works

- **How TokenCollector Works**

  1. **Subscribing Views**: Views that handle user input and conform to `SecureTextFieldProtocol` must be subscribed using the `subscribe(view:shouldTokenize:)` method, indicating whether the input should be tokenized.
  2. **Collecting Data**: After subscribing, collected data (tokenized or plain text) can be retrieved securely using the `collectSubscribedViews()` method.
  3. **Unsubscribing Views**: Views can be unsubscribed individually with `unsubscribe(fieldName:)` or all at once with `unsubscribeAllViews()` or `clearAllViews()`, removing them from future collection.



 ### Usage Overview

- [1. Create an Instance of TokenCollector](#1-create-an-instance-of-tokencollector)
- [2. Create Secure UI Component (Collect)](#2-create-secure-ui-component-collect)
  - [2.1 UIKit Integration (Collect)](#21-uikit-integration-collect)
  - [2.2 SwiftUI Integration (Collect)](#22-swiftui-integration-collect)

### 1. Create an Instance of TokenCollector

To securely capture sensitive user input within the UI, use the `TokenCollector` class.

The `TokenCollector` is responsible for **secure data collection**, managing views that conform to the `SecureTextFieldProtocol`. These views are registered using a **field name**, and their data is retrieved via the `collectSubscribedViews()` method. Tokenizable views will return tokenized values, while others return plain text.


##### 🔧 TokenCollector Properties

| Property              | Type                                | Description                                                                                                   |
| --------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| `tokenizableViews`    | `[String: SecureTextFieldProtocol]` | A dictionary of views that will securely tokenize user input, mapped by their field name.                     |
| `nonTokenizableViews` | `[String: SecureTextFieldProtocol]` | A dictionary of views that will return the plain text value without tokenization, mapped by their field name. |


##### 🔧 TokenCollector Methods

| Function                                                                                              | Description                                                                                                        |
| ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `subscribe(view: SecureTextFieldProtocol, shouldTokenize: Bool)`                                      | Subscribes the view to be collected.                                                                               |
| `unsubscribe(fieldName: String)`                                                                      | Removes the indicated field from the list to collect.                                                              |
| `unsubscribeAllViews()`                                                                               | Removes all subscripted views from the list to collect.                                                            |
| `clearAllViews()`                                                                                     | Resets all text fields by removing any entered data, returning them to their initial state.                        |
| `isContentEquals(_ firstFieldName: String, _ secondFieldName: String) -> Bool`                        | Compares the contents of two fields and returns true if they are equal, otherwise false.                           |
| `collectSubscribedViews(completion: @escaping (Result<[String: String], CollectTokenError>) -> Void)` | Collects data from all subscribed views and returns it in a dictionary format or an error if the collection fails. |


### 2. Create Secure UI Component (Collect)

To securely collect sensitive input from users, use a view that conforms to the `SecureTextFieldProtocol`.

These views are responsible for **secure data entry**, allowing user input to be collected and optionally tokenized. When a view is instantiated and registered via the `subscribe(view:shouldTokenize:)` method, it is associated with a **field name**, which acts as the key for identifying and retrieving the collected data later.

By conforming to `SecureTextFieldProtocol`, your component ensures:
- Custom UI configuration for a seamless user experience.
- Secure handling and validation of sensitive input.
- Optional tokenization of content during collection.

##### 🔧 SecureTextFieldProtocol Properties

| Property                 | Type                           | Description                                                                                                 |
| ------------------------ | ------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| `viewModel`              | `SecureTextFieldViewModel`     | Holds the view model that configures the appearance and behavior of the secure text field.                  |
| `state`                  | `SecureTextFieldStateProtocol` | Provides access to the current state of the secure text field, including its content and validation status. |
| `becomeFirstResponder()` | `Bool`                         | Makes the text field the first responder, allowing user input.                                              |
| `resignFirstResponder()` | `Bool`                         | Removes the text field as the first responder, dismissing the keyboard or input focus.                      |

##### 🔧 UI Configuration Functions

| Function                                                                  | Description                                                                   |
| ------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| `setUIConfiguration(_ uiConfig: SecureTextFieldUIConfigurationViewModel)` | Applies a complete set of UI configurations.                                  |
| `setTextColor(_ color: UIColor?)`                                         | Sets the text color for the field.                                            |
| `setBackgroundColor(_ color: UIColor?)`                                   | Sets the background color of the field.                                       |
| `setTintColor(_ color: UIColor?)`                                         | Sets the tint color for the field (typically used for the cursor or accents). |
| `setFont(_ font: UIFont?)`                                                | Sets the font used for the text.                                              |
| `setPlaceholder(text: String, textColor: UIColor?)`                       | Configures the placeholder text and its color.                                |
| `setCornerRadius(_ radius: CGFloat)`                                      | Adjusts the corner radius of the field's border.                              |
| `setBorderColor(_ color: UIColor?)`                                       | Sets the border color for the field.                                          |
| `setBorderWidth(_ width: CGFloat)`                                        | Defines the thickness of the border.                                          |


##### 🔧 State and Behavior Functions

| Function                      | Description                                               |
| ----------------------------- | --------------------------------------------------------- |
| `clearData()`                 | Clears any entered data in the text field.                |
| `setEnabled(_ enabled: Bool)` | Enables or disables user interaction with the text field. |


##### 🔧 SecureTextFieldViewModel Properties

Holds the view model that configures the appearance and behavior of the secure text field.

| Property          | Type                                      | Default     | Description                                                                    |
| ----------------- | ----------------------------------------- | ----------- | ------------------------------------------------------------------------------ |
| `fieldName`       | `String`                                  | -        | The name of the text field, used to identify it.                               |
| `fieldType`       | `FieldType`                               | `.none`     | Specifies the type of data being entered, such as cardNumber, cvv, etc.        |
| `shouldTokenize`  | `Bool`                                    | `true`      | Determines whether the input should be tokenized for security.                 |
| `regexPattern`    | `String?`                                 | `nil`       | An optional regular expression pattern to validate the input.                  |
| `validationRules` | `ValidationRules?`                        | `nil`       | Optional rules for validating the field's content, based on the field type.    |
| `maxLength`       | `Int?`                                    | `nil`       | The maximum allowed length for the input.                                      |
| `uiConfig`        | `SecureTextFieldUIConfigurationViewModel` | `.init()`   | Configuration for customizing the UI appearance of the text field.             |
| `properties`      | `SecureTextFieldPropertiesViewModel`      | `.init()`   | Additional properties that define the behavior and features of the text field. |
| `isEnabled`       | `Bool`                                    | `true`      | Indicates whether the text field is enabled for user interaction.              |
| `isVolatile`      | `Bool`                                    | `false`     | Indicates whether the data entered in the field is temporary and should be stored for a limited time. |


### Usage Steps

1. Create an instance of `TokenCollector`.
```swift
  `private var tokenCollector: TokenCollectorProtocol = TokenCollector()`
  ```

2. Use `subscribe(view:shouldTokenize:)` to register each `SecureTextFieldProtocol` view, indicating whether its content should be tokenized.

3. When ready to collect the data, call `collectSubscribedViews(completion:)`.

4. To stop collecting data:
   - Use `unsubscribe(fieldName:)` to remove a specific view.
   - Use `unsubscribeAllViews()` to remove all views at once.
    - To completely reset the collector (clearing all views and their data), use `clearAllViews()`.

#### 2.1 UIKit Integration (Collect)
UI component: SecureTextFieldProtocol created using a ComponentBuilder via the createSecureTextField function.

This function initializes a SecureTextFieldProtocol component with customizable behavior, allowing you to configure editing callbacks, state changes, validation failures, and secure data collection.

```swift
public static func createSecureTextField(
    viewModel: SecureTextFieldViewModel,
    didBeginEditing: VoidClosure? = nil,
    didEndEditing: VoidClosure? = nil,
    didChangeSelection: VoidClosure? = nil,
    didEndEditingOnReturn: VoidClosure? = nil,
    onStateChange: ((SecureTextFieldStateProtocol) -> Void)? = nil,
    onValidationFailure: (([String]) -> Void)? = nil,
    tokenCollector: TokenCollectorProtocol
) -> SecureTextFieldProtocol
```

##### 📘 createSecureTextField Function Parameters

| Property                | Type                                        | Description                                                                                                                 |
| ----------------------- | ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `viewModel`             | `SecureTextFieldViewModel`                  | The view model that configures the appearance and behavior of the secure text field.                                        |
| `didBeginEditing`       | `(() -> Void)?`                             | A closure that is triggered when the user starts editing the text field.                                                    |
| `didEndEditing`         | `(() -> Void)?`                             | A closure that is called when the user finishes editing the text field.                                                     |
| `didChangeSelection`    | `(() -> Void)?`                             | A closure that is invoked when the text selection changes within the text field.                                            |
| `didEndEditingOnReturn` | `(() -> Void)?`                             | A closure that is triggered when the user presses the return key and editing ends.                                          |
| `onStateChange`         | `((SecureTextFieldStateProtocol) -> Void)?` | A closure that notifies changes in the state of the text field, providing updates through the SecureTextFieldStateProtocol. |
| `onValidationFailure`   | `(([String]) -> Void)?`                     | A closure that is called when the text field fails validation, returning an array of validation error messages.             |
| `tokenCollector`        | `TokenCollectorProtocol`                    | The token collector responsible for capturing sensitive data entered into the text field for secure processing.             |

##### 📦 Example

```swift
private lazy var secureCardNumberTextField: SecureTextFieldProtocol = {
    let view = ComponentBuilder.createSecureTextField(
        viewModel: .init(fieldName: cardFieldName,
                         fieldType: .cardNumber(CardNumberMaskFormatter()),
                         uiConfig: .init(
                            textColor: .black,
                            backgroundColor: .white,
                            font: UIFont.systemFont(ofSize: 16, weight: .bold),
                            placeholder: Constants.Text.collectCardNumberPlaceholder,
                            cornerRadius: 8.0,
                            padding: .init(top: 8, left: 16, bottom: 8, right: 32),
                            borderWidth: 2.0
                         ),
                         properties: .init(
                            clearButtonMode: .always,
                            keyboardType: .numberPad
                         )),
        tokenCollector: tokenCollector)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}()
```

#### 2.2 SwiftUI Integration (Collect)

#### UI Component: `SecureTextFieldSwiftUI`

A SwiftUI wrapper around the UIKit-based `SecureTextField`, implemented using `UIViewRepresentable`. It allows seamless integration of a secure input field into SwiftUI views while preserving UIKit behavior and security mechanisms.

---

##### 🔧 SecureTextFieldViewModel Properties

| Property                  | Type                                          | Description |
|--------------------------|-----------------------------------------------|-------------|
| `viewModel`              | `SecureTextFieldViewModel`                    | Configures the appearance and behavior of the secure text field. |
| `didBeginEditing`        | `(() -> Void)?`                               | Triggered when the user starts editing the text field. |
| `didEndEditing`          | `(() -> Void)?`                               | Called when the user finishes editing the text field. |
| `didChangeSelection`     | `(() -> Void)?`                               | Invoked when the text selection changes. |
| `didEndEditingOnReturn`  | `(() -> Void)?`                               | Triggered when the user presses return and editing ends. |
| `onStateChange`          | `((SecureTextFieldStateProtocol) -> Void)?`   | Notifies state changes using the `SecureTextFieldStateProtocol`. |
| `onValidationFailure`    | `(([String]) -> Void)?`                       | Called when validation fails, providing an array of error messages. |
| `tokenCollector`         | `TokenCollectorProtocol`                      | Captures sensitive user input for secure processing. |

##### 📦 Example

```swift
@ViewBuilder
private var SecureCardNumberTextField: some View {
    SecureTextFieldSwiftUI(
        viewModel: .init(fieldName: cardFieldName,
                            fieldType: .cardNumber(CardNumberMaskFormatter()),
                            uiConfig: .init(
                              textColor: .black,
                              backgroundColor: .white,
                              font: UIFont.systemFont(ofSize: 16, weight: .bold),
                              placeholder: Constants.Text.collectCardNumberPlaceholder,
                              cornerRadius: 8.0,
                              padding: .init(top: 8, left: 16, bottom: 8, right: 32),
                              borderColor: self.getBorderColor(state: self.viewModel.cardNumberState),
                              borderWidth: 2.0
                            ),
                            properties: .init(
                              clearButtonMode: .always,
                              keyboardType: .numberPad
                            )),
        tokenCollector: tokenCollector)
    .frame(maxWidth: .infinity, maxHeight: 38, alignment: .leading)
}
```

### 🔍 Validation Priority

Validation logic varies slightly depending on the `fieldType`. Here's the order of precedence:

##### 🔒 For `cardNumber` and `expDate` Field Types

- Validation is **handled entirely** by the implementation of the `MaskFormatterProtocol`.
- **No other validation layers** (e.g. `regexPattern`, `validationRules`) are applied.

##### ✅ For All Other Field Types

Validation is applied in the following order:

1. **`maxLength`**  
   The first validation applied is the maximum allowed length of the input.

2. **`regexPattern`**  
   If a regular expression pattern is defined:
   - It will be used to validate the input.
   - If present, it overrides `validationRules`.

3. **`validationRules`**  
   These are applied *only if* no `regexPattern` is defined.
   - Rules are applied in the order they are declared.

##### 📝 Notes

- For certain `fieldType`s, if neither `regexPattern` nor `validationRules` is defined, **default validation rules** for that type are used.
- If `validationRules` is explicitly set as an empty array (`[]`), **no default rules will be applied**.
- `cardNumber` and `expDate` no longer fall back to any default validation behavior.

## Demo Application

Demo application on iOS is [here](https://github.com/astropay-it/tokenizer-ios/tree/develop/Example).

## License

Tokenizer iOS SDK is released under the MIT license. See [LICENSE](https://github.com/astropay-it/tokenizer-ios/blob/develop/LICENSE.rtf) for details.
