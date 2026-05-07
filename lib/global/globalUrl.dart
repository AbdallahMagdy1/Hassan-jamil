const webUrl = "http://localhost:3000/";
// const webUrl = "https://app.hassanjameelapp.com/";
// const webUrl = "https://fascinating-crumble-7b5594.netlify.app/";

// const baseDomain = "test.hassanjameelapp.com";
const baseDomain = "appmb.hassanjameelapp.com";

// Legacy sentinel kept so that `myRequest` can detect "default Visualbase
// call" and route it through the dedicated PagesController endpoints. Its
// value never reaches the network — every legacy op is rewritten to
// `<lang>/api/Pages/<Name>` against `backendUrl` before the HTTP call fires.
const baseUrl = "_legacy_visualbase_";
const administrationUrl = "https://$baseDomain/api/Administration/";
const backendUrl = "https://$baseDomain/";

const baseUrlWeb = "https://appmb.hassanjameelapp.com/api/";

const details = "details";
const func = "func";
const update = "update";
// const action = "Action";
// const add = "add";

const sendSms = "SendSms";
const getUserPhone = "GetUserPhone";
const sendFreeSms = "SendFreeSms";
const signup = "signup";

const SiteGetUserAccountTypes = "SiteGetUserAccountTypes";
const SiteGetCustomerAccountTypes = "SiteGetCustomerAccountTypes";
const UserFound = "UserFound";

// Validation endpoints
const SiteNewPhoneNumberExisting = "SiteNewPhoneNumberExisting";
const SiteNewEmailExisting = "SiteNewEmailExisting";
const SiteNewIdentityExisting = "SiteNewIdentityExisting";
const SiteNewCRExisting = "SiteNewCRExisting";
const SiteCheckUserHasNoPassword = "SiteCheckUserHasNoPassword";
