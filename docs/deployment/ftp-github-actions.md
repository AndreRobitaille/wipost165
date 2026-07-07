# FTP Deployment with GitHub Actions

This project deploys only the custom WordPress theme to shared hosting. It does not deploy WordPress core, uploads, database content, plugin settings, events, posts, or pages edited in wp-admin.

## Required GitHub secrets

Configure these repository secrets:

- `FTP_SERVER`: FTP host name.
- `FTP_USERNAME`: FTP user name.
- `FTP_PASSWORD`: FTP password.
- `FTP_SERVER_DIR`: remote directory for the theme, ending with `/wp-content/themes/post165/`.

## Deployment behavior

The workflow runs static validation, then uploads `wp-content/themes/post165/` to `FTP_SERVER_DIR`.

The workflow uses FTPS by default. Verify NixiHost/your host secure FTP mode before the first deployment.

The workflow is manual by default through `workflow_dispatch`. Automatic deployment on every push can be added later after the first successful manual deployment.

Use `ftps-legacy` only if the host requires it.

The third-party deploy action is pinned to an immutable commit for safety.

## Safety notes

- Confirm `FTP_SERVER_DIR` points to the theme directory before running deployment.
- Do not point `FTP_SERVER_DIR` at the WordPress root.
- Do not store FTP credentials in files.
- Do not expect wp-admin content changes to appear in Git after deployment.
