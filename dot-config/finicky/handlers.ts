import { heidiChromeProfile, personalChromeProfile } from "./browsers";
import type {
  BrowserHandler,
  BrowserSpecification,
} from "/Applications/Finicky.app/Contents/Resources/finicky.d.ts";

const heidiUrls = [
  "app.aus.vanta.com",
  "app.flagsmith.com",
  "app.incident.io",
  "cloud.mongodb.com",
  "eu.posthog.com",
  "github.com/oscerai",
  "heidi-dev.sentry.io",
  "heidi.kinde.com/admin",
  "heidihealth.bamboohr.com",
  "heidihealth.okta.com",
  "insideheidi.slack.com",
  "linear.app/getheidi",
  "scribe-admin-*.vercel.app",
  "us3.datadoghq.com",
  "vercel.com/heidi-health",
  "www.airwallex.com",
  "www.notion.so/heidihealth",
];
const personalUrls = [
  "github.com/willsawyerrrr",
  "www.notion.so/bronteandwill",
  "youtube.com",
];
const situUrls = ["github.com/SituDevelopment", "situworkspace.slack.com"];

function handleWithBrowser(browser: BrowserSpecification) {
  return function (url: string): BrowserHandler {
    return {
      browser,
      match: `https://${url}/*`,
    };
  };
}

export default [
  ...heidiUrls.map(handleWithBrowser(heidiChromeProfile)),
  ...personalUrls.map(handleWithBrowser(personalChromeProfile)),
  ...situUrls.map(handleWithBrowser(personalChromeProfile)),
];
