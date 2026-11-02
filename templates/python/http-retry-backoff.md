---
name: http-retry-backoff
language: python
tags: [python, http, retry, backoff, requests, reliability]
use-case: Retry an HTTP request with exponential backoff and jitter
created: 2026-07-31
---

## Description

Retries requests.get/post with exponential backoff, capped retries, and
random jitter to avoid thundering-herd. Raises the final exception if all
attempts fail.

## Usage

Call `http_get_with_retry(url, max_retries=3, base_delay=1.0, timeout=10)`.
Replace `requests.get` with `requests.post` and add `json=payload` for POST.

## Code

```python
import time
import random
import requests

def http_get_with_retry(
    url: str,
    max_retries: int = 3,
    base_delay: float = 1.0,
    timeout: int = 10,
) -> requests.Response:
    last_exc: Exception | None = None
    for attempt in range(max_retries):
        try:
            response = requests.get(url, timeout=timeout)
            response.raise_for_status()
            return response
        except (requests.RequestException, requests.HTTPError) as exc:
            last_exc = exc
            if attempt < max_retries - 1:
                delay = base_delay * (2 ** attempt) + random.uniform(0, 0.5)
                time.sleep(delay)
    raise last_exc  # type: ignore[misc]
```

## Notes

- Jitter prevents multiple clients retrying at the same instant.
- HTTPError from raise_for_status() is caught — distinguish 4xx vs 5xx if needed.
- For async: replace with httpx.AsyncClient and asyncio.sleep.
