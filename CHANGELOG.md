# Tokenizer - Changelog

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
