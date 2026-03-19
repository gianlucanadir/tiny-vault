# Changelog

## [2.2.4] - 2026-03-19

### Added
- Remove check latest version

## [2.2.3] - 2026-03-12

### Added
- Fix Start-TinyVaultWeb function

## [2.2.2] - 2026-03-12

### Added
- Minor fix

## [2.2.1] - 2026-03-12

### Added
- Add ASCII splash screen and current/latest version info

## [2.1.1] - 2026-03-12

### Added
- Add `Start-TinyVaultWeb` to easily start the web server

## [2.0.1] - 2026-03-08

### Fixed
- Improved error message in `Install-TinyVaultWeb` on download failure

## [2.0.0] - 2026-03-08

### Added
- AES-256 encryption with master password (PBKDF2 key derivation)
- `Install-TinyVaultWeb` command to download the web interface
- `Set-TinyVaultMasterPassword` command to change the vault master password

### Changed
- Vault format migrated from DPAPI to AES-256
- Vault moved to `$HOME\.tinyvault\vault.json`
