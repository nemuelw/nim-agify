# agify

Nim wrapper for the [Agify.io](https://agify.io) API

## Installation

```bash
nimble install agify
```

## Usage

### Import the package

```nim
import agify
```

### Initialize a client

```nim
let client = newAgifyClient("OPTIONAL_API_KEY")
```

### Get age for a single name

```nim
let ageResult = getAge("Nemuel")
if isOk(ageResult):
  echo ageResult.value.age
else: echo ageResult.error
```

### Get ages for multiple names

```nim
let agesResult = getAges(@["Nemuel", "Kira"])
if isOk(agesResult):
  for result in agesResult.value:
    echo result.age
else: echo agesResult.error
```

> Both the `getAge` and `getAges` methods have an optional second parameter (a country ID)

## Contributing

Contributions are welcome! Feel free to create an issue or open a pull request.

## License

This project is licensed under the terms of the [GNU GPL v3.0 License](https://www.gnu.org/licenses/gpl-3.0.html).
