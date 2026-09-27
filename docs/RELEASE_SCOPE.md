# Historical coming-soon release scope

This records the September 27 release branch before consolidation onto `main`.
The full-site development and documentation now live together on `main`; the
production coming-soon restriction below still applies.

The isolated release branch included the Rails runtime, its tests, deployment tooling,
and the retired WordPress runtime removal from the development checkout.
Unrelated design exploration and historical documentation changes remained in
the original checkout at release time. No member application files or production data are included.

The production configuration enables only the coming-soon page. The dormant
publishing consumer is not launch-ready; the live feed returned 404 during checks.
