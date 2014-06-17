                var hero_elem = document.getElementById('hero_bg');
                window.onscroll = function(){
                    var y = (window.pageYOffset !== undefined) ? window.pageYOffset : (document.documentElement || document.body.parentNode || document.body).scrollTop;
                    if(y < 800){
                        var translate = 'translate3d(0,'+(y * 0.4) +'px,0)';
                        hero_elem.style.WebkitTransform = translate;
                        hero_elem.style.MozTransform = translate;
                        hero_elem.style.msTransform = translate;
                        hero_elem.style.OTransform = translate;
                        hero_elem.style.transform = translate;
                    }
                };

