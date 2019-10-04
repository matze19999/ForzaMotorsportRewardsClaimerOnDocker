# ForzaMotorsportRewardsClaimerOnDocker

With this Dockerfile, you can automatically claim your weekly Forzamotorsport Rewards.

Python Script foked from https://github.com/Schamper/forza-rewards

## Base Image
Alpine | Latest

## Architecture
amd32 / amd64

## Image Size
- 24 MB

## Tutorial:

1. Login on forzamotorsport.net and click on "Redeem Rewards"

2. Open developer options with F12 and click on the categorie "application" or "cookies"

3. Now copy the content of the cookie "xlaWebAuth_1" (should begin with "ey" I think) and paste it into the token environment variable.
