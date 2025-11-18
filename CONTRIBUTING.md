# Contributing to VPN-Shadowsocks-libev

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists
2. Create a new issue with a clear title and description
3. Include:
   - Your system information (OS, version)
   - Steps to reproduce the issue
   - Expected behavior
   - Actual behavior
   - Error messages or logs

### Submitting Pull Requests

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/VPN-Shadowsocks-libev.git
   cd VPN-Shadowsocks-libev
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Add comments for complex logic
   - Update documentation if needed

4. **Test your changes**
   - Test on supported systems (Ubuntu/Debian)
   - Ensure installation script works
   - Verify uninstallation cleans up properly

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Provide a clear description of changes
   - Reference any related issues
   - Wait for review

## Code Style

### Bash Scripts

- Use 4 spaces for indentation
- Add comments for complex sections
- Use meaningful variable names
- Follow existing function naming patterns
- Include error handling

### Documentation

- Use clear, concise language
- Include code examples where appropriate
- Keep formatting consistent
- Update table of contents if needed

## Testing

Before submitting, test your changes:

```bash
# Test installation
sudo bash install.sh

# Verify service status
sudo systemctl status shadowsocks-libev

# Test uninstallation
sudo bash uninstall.sh
```

## Commit Messages

Write clear commit messages:

```
Add feature: Brief description

Detailed explanation of what changed and why.
Include any relevant issue numbers.

Fixes #123
```

## Documentation Updates

When making changes, update:

- README.md (if user-facing changes)
- CHANGELOG.md (add entry under [Unreleased])
- Relevant documentation in docs/
- Configuration examples if applicable

## Questions?

Feel free to open an issue for questions about contributing.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
