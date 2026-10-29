import { personalSafariProfile } from "./browsers";
import type {
  BrowserHandler,
  BrowserSpecification,
} from "~/Applications/Finicky.app/Contents/Resources/finicky.d.ts";

const personalUrls = [
  "*-willsawyerrrr.vercel.app",
  "github.com/willsawyerrrr",
  "willsawyerrrr.dev",
  "www.notion.so/bronteandwill",
  "youtube.com",
];

function handleWithBrowser(browser: BrowserSpecification) {
  return function (url: string): BrowserHandler {
    return {
      browser,
      match: `https://${url}/*`,
    };
  };
}

export default [...personalUrls.map(handleWithBrowser(personalSafariProfile))];
