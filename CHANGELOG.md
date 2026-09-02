# Tokenizer - Changelog

## [1.3.0] - 02/09/2026
### Changed

- **CVC is now always tokenized as volatile.** A CVC is sensitive authentication data that must not be retained beyond the authorization it was collected for, so a field configured with `fieldType: .cvc` is always sent to the Tokenizer API with `volatile: true`. The `isVolatile` property of `SecureTextFieldViewModel` is still honored for every other field type, but it can no longer lower this behavior for `cvc`: building the view model with `isVolatile: false` has no effect on that field type.
- **`RevealTokenError.tokenNotFound` no longer carries the submitted token.** The error previously echoed the token that was sent to the API, so it could leak into log lines, crash reports or screenshots through `localizedDescription`, `String(describing:)` or a `dump()`. The associated value was removed and the message is now `Token not found.`
This is a source-breaking change for callers that pattern match on the case with its associated value.

#### Example

##### Before:

```swift
tokenRevealer.revealSubscribedViews { result in
  if case .failure(.tokenNotFound(let token)) = result {
    logger.log("Reveal failed for token: \(token)")
  }
}
```

##### After:

```swift
tokenRevealer.revealSubscribedViews { result in
  if case .failure(.tokenNotFound) = result {
    // Use your own non-sensitive request identifier for support correlation.
    logger.log("Reveal failed: token not found (requestId: \(requestId))")
  }
}
```

## [1.2.0] - 26/03/2025
### Changed

Fixed an issue that allowed expired credit card expiration dates to be added. The SDK now ensures that only future expiration dates are accepted.

### Added

- Updated the `FieldType` struct to enhance handling of **cardNumber** and **expDate** fields. These fields now support implementations of a new `MaskFormatterProtocol` for real-time masking, unmasking, validation, and formatting based on the detected card brand. The SDK provides default implementations: `CardNumberMaskFormatter` and `CardExpirationDateMaskFormatter`. 
While you can implement your own `MaskFormatterProtocol`, we recommend using the provided formatters, as they include industry-standard validations such as Luhn algorithm check for card numbers, correct length enforcement based on the detected brand, and expiration date validation for dates (e.g., preventing expired dates).
- Removed **defaultValidation** and **defaultRegex** support from these field types, as validation is now managed through `MaskFormatterProtocol` implementation.

#### Example

##### Before:

```swift
SecureTextFieldSwiftUI(
  viewModel: .init(fieldName: "CardFieldName",
                  fieldType: .cardNumber,
                  ...
                  // Additional field configuration
  )
)

SecureTextFieldSwiftUI(
  viewModel: .init(fieldName: "CardExpDateName",
                  fieldType: .expDate,
                  ...
                  // Additional field configuration
  )
)
```

##### After:

```swift
SecureTextFieldSwiftUI(
  viewModel: .init(fieldName: "CardFieldName",
                  fieldType: .cardNumber(CardNumberMaskFormatter()),
                  ...
                  // Additional field configuration
  )
)

SecureTextFieldSwiftUI(
  viewModel: .init(fieldName: "CardExpDateName",
                  fieldType: CardExpirationDateMaskFormatter(dateFormat: .shortYear),
                  ...
                  // Additional field configuration
  )
)
```

## [1.1.2] - 14/11/2024
### Added
- Added option to copy value from SecureLabel with or without format.

## [1.1.1] - 27/09/2024
### Added
- Volatile property.

## [1.1.0] - 19/09/2024
### Added
- SecureTextField UIKit and SwiftUI components.
- TokenCollector feature to collect secure inputs into tokenized values.

## [1.0.1] - 07/08/2024
### Changed
- Lowered minimum supported iOS version to 12.0

## [1.0.0] - 08/07/2024
### Added
- SecureLabel UIKit and SwiftUI components and ComponentBuider object.
- Environment, config and dependencies objects.
- Networking layer.
- Service layer and TokenRevealer object for reveal tokens.
- Initial release of Tokenizer.xcframework with support for simulators and physical devices.
