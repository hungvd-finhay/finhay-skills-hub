const crypto = require("crypto");

const [method, requestPath, queryParams] = process.argv.slice(2);
if (!method || !requestPath) {
  console.error('Usage: request.sh METHOD PATH [QUERY]\nExample: request.sh GET /market/stock-realtime "symbol=VNM"');
  process.exit(1);
}

const apiKey = process.env.FINHAY_API_KEY;
const apiSecret = process.env.FINHAY_API_SECRET;
const baseUrl = process.env.FINHAY_BASE_URL || "https://open-api.fhsc.com.vn";

if (!apiKey || !apiSecret) {
  console.error("ERROR: FINHAY_API_KEY and FINHAY_API_SECRET required.\nSet via environment variables or ~/.finhay/credentials/.env");
  process.exit(1);
}

const timestamp = String(Date.now());
const signature = crypto
  .createHmac("sha256", apiSecret)
  .update(`${timestamp}\n${method}\n${requestPath}\n`)
  .digest("hex");

const url = `${baseUrl}${requestPath}${queryParams ? `?${queryParams}` : ""}`;

fetch(url, {
  method,
  headers: {
    "X-FH-APIKEY": apiKey,
    "X-FH-TIMESTAMP": timestamp,
    "X-FH-NONCE": crypto.randomBytes(16).toString("hex"),
    "X-FH-SIGNATURE": signature,
    "User-Agent": "finhay-skill/1.0.0",
  },
  signal: AbortSignal.timeout(30000),
})
  .then(async (res) => {
    const body = await res.text();
    if (res.status >= 400) {
      console.error(`ERROR: HTTP ${res.status}\n${body}`);
      process.exit(1);
    }
    try {
      const json = JSON.parse(body);
      if (json.error_code && json.error_code !== "0") {
        console.error(`ERROR: error_code=${json.error_code}\n${body}`);
        process.exit(1);
      }
    } catch {}
    process.stdout.write(body);
  })
  .catch((e) => {
    console.error(`ERROR: ${e.message}`);
    process.exit(1);
  });
