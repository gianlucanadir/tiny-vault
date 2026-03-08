# Changelog

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
