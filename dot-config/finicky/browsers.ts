import { BrowserSpecification } from "~/Applications/Finicky.app/Contents/Resources/finicky";

export enum Browser {
  GoogleChrome = "Google Chrome",
  Safari = "Safari",
}

export const personalChromeProfile: BrowserSpecification = {
  name: Browser.GoogleChrome,
  profile: "Personal",
};

export const personalSafariProfile: BrowserSpecification = {
  name: Browser.Safari,
  profile: "Personal",
};
