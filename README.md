# Observium cookbook

Observium cookbook installs [_Observium_](http://www.observium.org) network monitoring platform.

## Supported Platforms

- CentOS 6
- Ubuntu 14.04
- Debian 7

## Usage

### observium::default

Include `observium` in your node's `run_list`:

```
{
  "run_list": [
    "recipe[observium::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author: Petar Koraca (pkoraca@gmail.com)
