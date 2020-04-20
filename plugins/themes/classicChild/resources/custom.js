var slideIndex = 0;
var slides = document.getElementsByClassName("mySlides");

if(document.body.contains(document.getElementById('slideshow-container'))){
    showSlides();
} else {
    console.log('Element does not exist!');
}

function hasText(slide) {
    if(slide.getElementsByClassName("text").length > 0) {
        return true;
    } else {
        return false;
    }
}

function showSlides() {
  var i;
  var slides = document.getElementsByClassName("mySlides");
  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";  
  }
  slideIndex++;
  if (slideIndex > slides.length) {slideIndex = 1}    
  slides[slideIndex-1].style.display = "block"; 

  if (hasText(slides[slideIndex-1])) {
    setTimeout(showSlides, 10000);
  } else {
    setTimeout(showSlides, 5000);
  }
}



// Function Banner
const banner = document.getElementById("banner");

function closeBanner(banner) {
   this.banner.classList.remove("active");
}

const modalCover = document.getElementById("modalCover");
function openBanner(modalCover) {
    this.modalCover.classList.toggle("show")
    document.body.classList.toggle("modal-open")
}
//var loadfirst = sessionStorage.getItem('loadfirsttime');
//if(loadfirst == null){
//    sessionStorage.setItem('loadfirsttime', 1); // 1 is value assigned.
//    banner.classList.add("active");
//}

var allItemAbstracts = document.getElementsByClassName('btn_abstract')
function expandAbstract(el) {
    Array.from(allItemAbstracts).forEach(element => {
        if ( element == el ) {
            
        } else {
            element.classList.remove('open');
        }
    });
    el.classList.toggle('open')
}




/*
* Efectos para fijar el navegador secundario
* en las revistas y articulos
*/
var $main = document.getElementsByTagName('main')[0];
function isPageIssue() { return $main.classList.contains('page_issue'); }
function isPageArticle() { return $main.classList.contains('page_article'); }
function isPageSearch() { return $main.classList.contains('page_searchresults'); }
function isPageArticlesByGroup() { return $main.classList.contains('page_articlesbygroup'); }
function isPageBook() { return $main.classList.contains('page_book'); }
function isPageChapter() { return $main.classList.contains('page_chapterstandard'); }
// function isPageSelfServe() { return $body.hasClass('pg_selfserve/sspage') || $body.hasClass('pg_selfservepage'); }








//Variables para el efecto del primary nav y el secondary nav
var contentNav = $('.issue-browse-top')[0],
    contentNavTopPosition = contentNav.offsetTop,
    scrollMenu = $('#scrollMenu')[0],
    closeContentNav = scrollMenu.getElementsByTagName('button')[0],
    sections = $('.sections .section'),
    nav = $('#largeJumptoSection li'),
    tabNavs = $('.artTypeJumpLinks li'),
    nav_height = scrollMenu.offsetHeight;

    //Variables en Desktop
var issueHeading = $('.issue_heading')[0],
issueHeadingTopPosition = issueHeading.offsetTop,
bodyHeight = document.body.clientHeight,
footerHeight = document.getElementsByTagName('footer')[0].clientHeight;


$(window).on('scroll', function(){
    console.log($(window).scrollTop())
    console.log(bodyHeight - window.innerHeight)
    //on desktop - fix secondary navigation on scrolling
    if($(window).scrollTop() > contentNavTopPosition ) {
        contentNav.classList.add('stuck');
    } else {
        contentNav.classList.remove('stuck');
    }
    if($(window).scrollTop() > issueHeadingTopPosition ) {
        issueHeading.classList.add('stuck');
    } else {
        issueHeading.classList.remove('stuck');
    }
    if($(window).scrollTop() > (bodyHeight - window.innerHeight - footerHeight) ) {
        issueHeading.classList.add('stop');
    } else {
        issueHeading.classList.remove('stop');
    }
    //on desktop - update the active link in the secondary fixed navigation
    // updateSecondaryNavigation();
    var cur_pos = $(this).scrollTop();

    Array.from(sections).forEach( el => {
        var top = el.offsetTop - nav_height - contentNav.offsetHeight,
            bottom = top + el.offsetHeight;
            el.classList.remove('active');
            for (var i = 0; i < tabNavs.length; i++) {
                var tab = tabNavs[i]
                var refTab = tab.querySelectorAll('a[href="#'+el.getAttribute('id')+'"]')
                if (cur_pos >= top && cur_pos <= bottom) {
                    el.classList.add('active')
                    if ( refTab.length < 1) {
                        tab.classList.remove('active')
                    } else {
                        // console.log(refTab.length)
                        refTab[0].parentElement.classList.add('active')
                    }
                }
            }
    });

});

contentNav.addEventListener('click', function() {
    scrollMenu.style.display = 'block'
    document.body.classList.add('noscroll')
});
closeContentNav.addEventListener('click', function() {
    scrollMenu.style.display = null
    document.body.classList.remove('noscroll')
});

Array.from(nav).forEach( lit =>{
    lit.addEventListener('click', function(){
        scrollMenu.style.display = null
        document.body.classList.remove('noscroll')
    })
})

// tabNavs.find('.section-jump-link a').on('click', function () {
//     var $el = $(this), 
//         id = $el.attr('href');
//     console.log('paso por aqui')
//     $('html, body').animate({
//         scrollTop: $(id).offset().top - nav_height
//     }, 500);
    
//     return false;
// });





/**
    * Request new rAF if not active
    */
   function requestTick() {
    if (!ticking) {
        requestAnimationFrame(updateStickyElements);
        ticking = true;
    }
}



function updateStickyElements() {
    ticking = false;

    // Article page article toolbar
    updateStickyToolbar();
    // updateRightRail();
    // updateLeftNav();
    // updateSearchStickyToolbar();

    // if (isPageIssue()) {
    //     updateIssueLeftNav();
    // }

    // updateAdvertScrollDelay();
    // updateAdvertGuardian();
}

// checking every time because google ads aren't always loaded by document.ready()
// var _hasTopAd = null;
// function hasTopAd() {
//     if (!_hasTopAd) {
//         _hasTopAd = $("#adBlockHeader iframe").length;
//     }
//     return _hasTopAd;
// }

// var _hasRightRailAd = null;
// function hasRightRailAd() {
//     if (!_hasRightRailAd) {
//         _hasRightRailAd = $("#Sidebar>div:last-of-type iframe").length;
//     }
//     return _hasRightRailAd;
// }

function updateStickyToolbar() {
    // if (SCM.SiteJS.getViewportWidth() > 1023) {
        if (isPageArticle() || isPageIssue()) {
            if (lastScrollPosY >= $('.js-content-body').offset().top + toolbarHeight) {
                $stickyToolbar.addClass("stuck");
            } else {
                $stickyToolbar.removeClass("stuck");
            }
        }
    // }
}

function updateRightRail() {
    // Right Rail Bottom Ad Sticky
    // For layouts with Desktop size breakpoint for Right Sidebar response
    if ($adRightConfig === "sticky" && hasRightRailAd()) {
        var adBreakScrollPosY;
        if (hasRightRailAd() && SCM.SiteJS.getViewportWidth() > 1200) {
            if (isPageArticle()) { // Article page with fixed top menu
                $scrollHeight =
                    50 +
                    $rightRail.height() +
                    $header.height(); // +50 for main padding
                adBreakScrollPosY =
                    $scrollHeight -
                    $rightRailAd.height() -
                    80; // account for fixed article menu, top: 80 for Ad w/ fixed menu.

                if (lastScrollPosY >= adBreakScrollPosY) {
                    $rightRail.css('height', $rightRail.height());
                    $rightRailAdContainer.addClass("fixed");
                } else {
                    $rightRail.css('height', 'auto');
                    $rightRailAdContainer.removeClass("fixed");
                }
            }

            if (isPageIssue() || isPageSearch() || isPageBook() || isPageChapter()) { // Issue, Search Pages
                $scrollHeight =
                    50 +
                    $rightRail.height() +
                    $header.height(); // +50 for main padding
                adBreakScrollPosY = $scrollHeight - $rightRailAd.height() - 24; // top: 24 for Ad w/out fixed menu.
                if (lastScrollPosY >= adBreakScrollPosY) { // padding, including responsive article menu
                    $rightRail.css('height', $rightRail.height());
                    $rightRailAdContainer.addClass("fixed");
                } else {
                    $rightRail.css('height', 'auto');
                    $rightRailAdContainer.removeClass("fixed");
                }
            }
        } else {
            $rightRailAdContainer.removeClass("fixed");
        }

        // Right Rail Bottom Ad Sticky
        // For layouts with Tablet size breakpoint for Right Sidebar response
        if (hasRightRailAd() && SCM.SiteJS.getViewportWidth() > 1023) {
            if (isPageArticlesByGroup()) {
                // Undo CSS bottom margin for bottom Ad on articles by group.
                $(".pg_articlesbygroup #Sidebar .widget:last-of-type").css('margin-bottom', '0');
            }
            if (isPageArticlesByGroup() || isPageSelfServe()) { // Issue, Search Pages
                $scrollHeight =
                    50 +
                    $rightRail.height() +
                    $header.height(); // +50 for main padding
                adBreakScrollPosY = $scrollHeight - $rightRailAdContainer.height() - 24; // top: 24 for Ad w/out fixed menu.
                if (lastScrollPosY >= adBreakScrollPosY) { // padding, including responsive article menu
                    $rightRail.css('height', $rightRail.height());
                    $rightRailAdContainer.addClass("fixed");
                } else {
                    $rightRail.css('height', 'auto');
                    $rightRailAdContainer.removeClass("fixed");
                }
            }
        } else {
            $rightRailAdContainer.removeClass("fixed");
        }
    }

}

// Cache value
var _isToolbarCloned = null;
function isToolbarCloned() {
    if (_isToolbarCloned === null) {
        _isToolbarCloned = $stickyToolbar.children().length;
    }
    return _isToolbarCloned;
}

function cloneToolbarToStickyToolbar() {
    if (!isToolbarCloned()) {
        var $clone = $toolbarWrap.clone();
        $stickyToolbar.append($clone);
        if (typeof addthis !== "undefined") {
            addthis.toolbox(".js-sticky-toolbar");
        }
        _isToolbarCloned = true;
    }
}

function updateLeftNav() {

    // ViewLarge has an undefined $header, therefore if view is ViewLarge
    // we will skip this function so MathJax can execute properly
    if (SCM.SiteJS.isPageViewLarge()) {
        return;
    }

    var guardianAdHeight = 0;
    if ($adTopConfig === "guardian" && hasTopAd()) {
        guardianAdHeight = $adBannerTop.height();
    }

    if (lastScrollPosY >= $header.height()
                        + $header.offset().top
                        + guardianAdHeight
                        - leftNavStickyOffset) {

        if (isPageArticle() || isPageChapter()) {
            cloneToolbarToStickyToolbar();

            $leftNavColumn.addClass("stuck");
            $leftNav.css('top', '55px');
            $mobileNav.addClass("stuck");
        }

        // Search Results (only for tablet/mobile)
        if (isPageSearch() && SCM.SiteJS.getViewportWidth() <= 1023) {
            $srFilters.addClass("stuck");
        }

    } else {
        // remove fixed from all 'sticky' elements
        if (isPageArticle() || isPageSearch() || isPageChapter()) {
            $leftNav.css('top', '0px');
            $stickyElements.removeClass("stuck");
        }
    }
}

function updateSearchStickyToolbar() {
    if (isPageSearch() && SCM.SiteJS.getViewportWidth() <= 1023) {
        if (lastScrollPosY >= $header.height() + 148 + 70) {
            // Search Results (only for tablet/mobile)
            $srFilters.addClass("stuck");
            $srFilters.next().css('margin-top', '70px');

        } else {
            // remove fixed from all 'sticky' elements
            $stickyElements.removeClass("stuck");
            $srFilters.next().css('margin-top', '0px');
        }
    }
}

function updateIssueLeftNav() {
    var $issueDropdownWrap = $main.getElementsByClassName('.js-issue-dropdown-wrap')[0];
    var issueDropdownBottomMargin = parseInt($issueDropdownWrap.css('margin-bottom').replace('px', ''));

    if (SCM.SiteJS.getViewportWidth() > 1023) {
        if (lastScrollPosY >= $header.height()
                            + $issueDropdownWrap.height()
                            + issueDropdownBottomMargin * 2
                            + $header.offset().top) {
            // Issue Results
            $leftNavColumn.addClass("stuck");
        } else if (isPageIssue()) {
            $leftNavColumn.removeClass("stuck");
        }
    }

    if (lastScrollPosY >= $header.height()
                        + $issueDropdownWrap.height()
                        + issueDropdownBottomMargin * 2
                        + $header.offset().top
                        + $leftNavColumn.height() + 30) {

        $issueBrowseMobileNav.addClass("stuck");
        if (SCM.SiteJS.getViewportWidth() <= 1023) {
            $issueBrowseMobileNav.parent().css('padding-top', ($issueBrowseMobileNav.height() + 32) + 'px');
        }

    } else if (isPageIssue()) {

        $issueBrowseMobileNav.removeClass("stuck");
        if (SCM.SiteJS.getViewportWidth() <= 1023) {
            $issueBrowseMobileNav.parent().css('padding-top', '0px');
        }

    }// >= 620
}

function updateAdvertScrollDelay() {
    if ($adTopConfig === "scrolldelay" && $useAdTopDelay === true && hasTopAd()) {
        if (lastScrollPosY >= $header.height() - 290) {
            $adBannerTop.addClass("fixed");
            $mainPage.addClass("master-container-sticky");
        }
        else {
            $adBannerTop.removeClass("fixed");
            $mainPage.removeClass("master-container-sticky");
        }
    }
}

function updateAdvertGuardian() {
    if ($adTopConfig === "guardian" && hasTopAd()) {
        if (lastScrollPosY >= $header.height() - 290 && lastScrollPosY < 220) {
            $adBannerTop.addClass("fixed");
            $adBannerTop.removeClass("guardian-scrolled");
            $mainPage.addClass("master-container-sticky");
            $(".journal-header").show();
        }
        else if (lastScrollPosY >= 220) {
            $adBannerTop.removeClass("fixed");
            $adBannerTop.addClass("guardian-scrolled");
            $mainPage.addClass("master-container-sticky");
            $(".journal-header").hide();
        }
        else {
            $adBannerTop.removeClass("fixed");
            $adBannerTop.removeClass("guardian-scrolled");
            $mainPage.removeClass("master-container-sticky");
            $(".journal-header").show();
        }
    }
}
