with (import ../keys).infra.sshKeys; let
  coreKeys = [ aciceri.key zarelit.key github.key ];
in
{
  "AWS_ACCESS_KEY_ID.age".publicKeys = coreKeys;
  "AWS_SECRET_ACCESS_KEY.age".publicKeys = coreKeys;
  "AWS_ENDPOINT_URL_S3.age".publicKeys = coreKeys;

  "TF_VAR_cloudflare_account_id.age".publicKeys = coreKeys;
  "TF_VAR_cloudflare_api_token.age".publicKeys = coreKeys;
  "TF_VAR_cloudflare_dns_token.age".publicKeys = coreKeys;

  "TF_VAR_hcloud_token.age".publicKeys = coreKeys;

  "CACHIX_AUTH_TOKEN.age".publicKeys = coreKeys;
}
