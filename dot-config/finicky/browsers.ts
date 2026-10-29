import { BrowserSpecification } from "~/Applications/Finicky.app/Contents/Resources/finicky";

export enum Browser {
  GoogleChrome = "Google Chrome",
}

export const personalChromeProfile: BrowserSpecification = {
  name: Browser.GoogleChrome,
  profile: "Personal",
};
