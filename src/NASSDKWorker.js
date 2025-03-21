/**
 * Thiết lập cho cache
 */
const CACHE_NAME = 'blanas-sw-cache-1731150247';
const urlsToCache = [
    '/assets/images/pix.svg',

    // Các url này cần cẩn thận vì nó ko phải là tệp tĩnh hoàn toàn
    '/uploads/icons/nas-fav.png',
    '/themes/blanas/AppImages/ios/192.png',
    '/themes/blanas/AppImages/ios/144.png',
    '/uploads/bg-2.jpg',

    '/manifest.webmanifest',

    '/assets/fonts/fontawesome-webfont.woff2',
    '/themes/default/fonts/NukeVietIcons.woff2',
    '/themes/blanas/fonts/BeVietnamPro-Black.woff',
    '/themes/blanas/fonts/BeVietnamPro-Black.woff2',
    '/themes/blanas/fonts/BeVietnamPro-BlackItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-BlackItalic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-Bold.woff',
    '/themes/blanas/fonts/BeVietnamPro-Bold.woff2',
    '/themes/blanas/fonts/BeVietnamPro-BoldItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-BoldItalic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-ExtraBold.woff',
    '/themes/blanas/fonts/BeVietnamPro-ExtraBold.woff2',
    '/themes/blanas/fonts/BeVietnamPro-ExtraBoldItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-ExtraBoldItalic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-ExtraLight.woff',
    '/themes/blanas/fonts/BeVietnamPro-ExtraLight.woff2',
    '/themes/blanas/fonts/BeVietnamPro-ExtraLightItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-ExtraLightItalic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-Italic.woff',
    '/themes/blanas/fonts/BeVietnamPro-Italic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-Light.woff',
    '/themes/blanas/fonts/BeVietnamPro-Light.woff2',
    '/themes/blanas/fonts/BeVietnamPro-LightItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-LightItalic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-Medium.woff',
    '/themes/blanas/fonts/BeVietnamPro-Medium.woff2',
    '/themes/blanas/fonts/BeVietnamPro-MediumItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-MediumItalic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-Regular.woff',
    '/themes/blanas/fonts/BeVietnamPro-Regular.woff2',
    '/themes/blanas/fonts/BeVietnamPro-SemiBold.woff',
    '/themes/blanas/fonts/BeVietnamPro-SemiBold.woff2',
    '/themes/blanas/fonts/BeVietnamPro-SemiBoldItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-SemiBoldItalic.woff2',
    '/themes/blanas/fonts/BeVietnamPro-Thin.woff',
    '/themes/blanas/fonts/BeVietnamPro-Thin.woff2',
    '/themes/blanas/fonts/BeVietnamPro-ThinItalic.woff',
    '/themes/blanas/fonts/BeVietnamPro-ThinItalic.woff2',
    '/themes/blanas/fonts/boxicons.eot',
    '/themes/blanas/fonts/boxicons.svg',
    '/themes/blanas/fonts/boxicons.ttf',
    '/themes/blanas/fonts/boxicons.woff',
    '/themes/blanas/fonts/boxicons.woff2',
    '/themes/blanas/webfonts/fa-brands-400.ttf',
    '/themes/blanas/webfonts/fa-brands-400.woff2',
    '/themes/blanas/webfonts/fa-regular-400.ttf',
    '/themes/blanas/webfonts/fa-regular-400.woff2',
    '/themes/blanas/webfonts/fa-solid-900.ttf',
    '/themes/blanas/webfonts/fa-solid-900.woff2',
    '/themes/blanas/webfonts/fa-v4compatibility.ttf',
    '/themes/blanas/webfonts/fa-v4compatibility.woff2',

    '/assets/js/jquery/jquery.min.js',
    '/assets/js/jquery-ui/jquery-ui.min.js',
    '/assets/js/clipboard/clipboard.min.js',
    '/assets/js/plyr/plyr.polyfilled.js',
    '/assets/js/language/vi.js',
    '/assets/js/DOMPurify/purify3.js',
    '/assets/js/global.js',
    '/assets/js/site.js',
    '/assets/js/perfect-scrollbar/min.js',
    '/assets/js/language/plupload-vi.js',

    '/themes/blanas/js/bootstrap.bundle.min.js',
    '/themes/blanas/js/long-press-event.min.js',
    '/themes/blanas/js/jquery.touchSwipe.min.js',
    '/themes/blanas/js/nv.core.js',
    '/themes/blanas/js/nas.main.js',
    '/themes/blanas/js/nas.drive.js',
    '/themes/blanas/js/nas.file.js',
    '/themes/blanas/js/nas.rtc.js',
    '/themes/blanas/js/nas.zone.js',

    '/assets/js/perfect-scrollbar/style.css',
    '/assets/js/jquery-ui/jquery-ui.min.css',
    '/assets/js/plyr/plyr.css',

    '/themes/blanas/css/boxicons.min.css',
    '/themes/blanas/css/nv.style.css',
];

/**
 * Sự kiện khi install Service Worker lần đầu tiên
 */
self.addEventListener('install', event => {
    event.waitUntil(
        // Thiết lập cache các tệp tĩnh
        caches.open(CACHE_NAME).then(cache => {
            console.log('Setting up cached!');
            return cache.addAll(urlsToCache);
        })
    );
});

/**
 * Sự kiện ngay sau khi install Service Worker
 */
self.addEventListener('activate', event => {
    console.log('SW activate event');
    const cacheWhitelist = [CACHE_NAME];
    event.waitUntil(
        // Xóa các cache cũ không còn trong danh sách cache
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (!cacheWhitelist.includes(cacheName)) {
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
});

/**
 * Sự kiện khi có request, kể cả request vào tệp tĩnh
 */
self.addEventListener('fetch', event => {
    const url = new URL(event.request.url);

    // Không xử lý event dạng ajax
    if (url.searchParams.has('nocache') && /^[0-9]{10,}$/.test(url.searchParams.get('nocache'))) {
        return;
    }
    // Không xử lý các request đến php
    if (!/^(\/(themes|assets|uploads|data)\/)/.test(url.pathname) && url.pathname != '/manifest.webmanifest') {
        return;
    }

    // Xử lý cache các tệp tĩnh
    event.respondWith(
        // Kiểm tra request có trong cache không nếu có lấy ra
        caches.match(event.request, { ignoreSearch: true }).then(response => {
            // Trả về từ cache nếu có sẵn
            if (response) {
                return response;
            }
            // Nếu không có trong cache, tải từ mạng
            return fetch(event.request);
        })
    );
});
