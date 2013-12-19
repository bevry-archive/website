// Generated by CoffeeScript 1.6.3
(function() {
  var appPath, contributors, contributorsGetter, docpadConfig, fsUtil, getCategoryName, getLabelName, getLinkName, getName, getProjectName, humanize, isProduction, moment, pathUtil, pin, requireFresh, rootPath, sitePath, templateData, textData, websiteVersion,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  fsUtil = require('fs');

  pathUtil = require('path');

  moment = require('moment');

  requireFresh = require('requirefresh').requireFresh;

  rootPath = pathUtil.resolve(__dirname + '/../..');

  appPath = __dirname;

  sitePath = rootPath + '/site';

  templateData = requireFresh(appPath + '/templateData');

  textData = templateData.text;

  websiteVersion = requireFresh(rootPath + '/package.json').version;

  contributorsGetter = null;

  contributors = null;

  pin = null;

  isProduction = process.env.NODE_ENV === 'production';

  getName = function(a, b) {
    var _ref, _ref1;
    if (b === null) {
      return (_ref = textData[b]) != null ? _ref : humanize(b);
    } else {
      return (_ref1 = textData[a][b]) != null ? _ref1 : humanize(b);
    }
  };

  getProjectName = function(project) {
    return getName('projectNames', project);
  };

  getCategoryName = function(category) {
    return getName('categoryNames', category);
  };

  getLinkName = function(link) {
    return getName('linkNames', link);
  };

  getLabelName = function(label) {
    return getName('labelNames', label);
  };

  humanize = function(text) {
    var piece;
    if (text == null) {
      text = '';
    }
    text = text.replace(/[-_]/g, ' ').replace(/\s+/g, ' ');
    text = ((function() {
      var _i, _len, _ref, _results;
      _ref = text.split(' ');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        piece = _ref[_i];
        _results.push(piece.substr(0, 1).toUpperCase() + piece.substr(1));
      }
      return _results;
    })()).join(' ');
    return text;
  };

  docpadConfig = {
    rootPath: rootPath,
    outPath: rootPath + '/site/out',
    srcPath: rootPath + '/site/src',
    reloadPaths: [appPath],
    regenerateEvery: 1000 * 60 * 60 * 24,
    templateData: require('extendr').extend(templateData, {
      uniq: require('uniq'),
      moment: moment,
      nodeVersion: process.version,
      nodeMajorMinorVersion: process.version.replace(/^v/, '').split('.').slice(0, 2).join('.'),
      site: {
        url: "http://bevry.me",
        title: "Bevry - Node.js, Backbone.js & JavaScript Consultancy in Sydney, Australia",
        description: "We're a Node.js, Backbone.js and JavaScript consultancy in Sydney Australia with a focus on empowering developers. We've created History.js one of the most popular javascript projects in the world, and DocPad an amazing Node.js Content Management System. We’re also working on setting up several Startup Hostels all over the world, enabling entreprenuers to travel, collaborate, and live their dream lifestyles cheaper than back home.",
        keywords: "bevry, bevryme, balupton, benjamin lupton, docpad, history.js, node, node.js, javascript, coffeescript, startup hostel, query engine, queryengine, backbone.js, cson",
        services: {
          pin: process.env.BEVRY_PIN_API_KEY_PUBLIC,
          gittipButton: 'bevry',
          flattrButton: '344188/balupton-on-Flattr',
          paypalButton: 'QB8GQPZAH84N6',
          gauges: '5077ad8cf5a1f5067b000027',
          googleAnalytics: 'UA-35505181-1',
          reinvigorate: '52uel-236r9p108l'
        },
        styles: ['/styles/style.css'].map(function(url) {
          return "" + url + "?websiteVersion=" + websiteVersion;
        }),
        scripts: [(isProduction ? "https://api.pin.net.au/pin.js" : "https://test-api.pin.net.au/pin.js"), "/vendor/jquery.js", "/vendor/log.js", "/vendor/jquery.scrollto.js", "/vendor/modernizr.js", "/vendor/history.js", "/vendor/historyjsit.js", "/scripts/payment.js", "/scripts/bevry.js", "/scripts/script.js"].map(function(url) {
          return "" + url + "?websiteVersion=" + websiteVersion;
        })
      },
      getName: getName,
      getProjectName: getProjectName,
      getCategoryName: getCategoryName,
      getLinkName: getLinkName,
      getLabelName: getLabelName,
      getPreparedTitle: function() {
        if (this.document.pageTitle !== false && this.document.title) {
          return "" + (this.document.pageTitle || this.document.title) + " | " + this.site.title;
        } else if (this.document.pageTitle === false || (this.document.title != null) === false) {
          return this.site.title;
        }
      },
      getPreparedDescription: function() {
        return this.document.description || this.site.description;
      },
      getPreparedKeywords: function() {
        return this.site.keywords.concat(this.document.keywords || []).join(', ');
      },
      readFile: function(relativePath) {
        var path, result;
        path = this.document.fullDirPath + '/' + relativePath;
        result = fsUtil.readFileSync(path);
        if (result instanceof Error) {
          throw result;
        } else {
          return result.toString();
        }
      },
      codeFile: function(relativePath, language) {
        var contents;
        if (language == null) {
          language = pathUtil.extname(relativePath).substr(1);
        }
        contents = this.readFile(relativePath);
        return "<pre><code class=\"" + language + "\">" + contents + "</code></pre>";
      },
      getContributors: function() {
        return contributors || [];
      }
    }),
    collections: {
      learn: function(database) {
        var query, sorting;
        query = {
          relativePath: {
            $startsWith: 'learn'
          },
          body: {
            $ne: ""
          },
          ignored: false
        };
        sorting = [
          {
            projectDirectory: 1,
            categoryDirectory: 1,
            filename: 1
          }
        ];
        return database.findAllLive(query, sorting).on('add', function(document) {
          var a, absoluteLink, basename, category, categoryDirectory, categoryName, editUrl, githubEditUrl, layout, longLink, name, organisation, organisationDirectory, organisationName, pageTitle, pathDetails, pathDetailsExtractor, project, projectDirectory, projectName, proseEditUrl, shortLink, standalone, title, urls;
          a = document.attributes;
          /*
          				learn/#{organisation}/#{project}/#{category}/#{filename}
          */

          pathDetailsExtractor = /^.*?learn\/(.+?)\/(.+?)\/(.+?)\/(.+?)\.(.+?)$/;
          pathDetails = pathDetailsExtractor.exec(a.relativePath);
          layout = 'doc';
          standalone = true;
          organisationDirectory = organisation = organisationName = projectDirectory = project = projectName = categoryDirectory = category = categoryName = title = pageTitle = null;
          if (pathDetails != null) {
            organisationDirectory = pathDetails[1];
            projectDirectory = pathDetails[2];
            categoryDirectory = pathDetails[3];
            basename = pathDetails[4];
            organisation = organisationDirectory.replace(/[\-0-9]+/, '');
            organisationName = humanize(project);
            project = projectDirectory.replace(/[\-0-9]+/, '');
            projectName = getProjectName(project);
            category = categoryDirectory.replace(/^[\-0-9]+/, '');
            categoryName = getCategoryName(category);
            name = basename.replace(/^[\-0-9]+/, '');
            title = "" + (a.title || humanize(name));
            pageTitle = "" + title + " | " + projectName;
            absoluteLink = longLink = "/learn/" + project + "-" + name;
            shortLink = "/" + project + "/" + name;
            urls = [longLink, shortLink];
            githubEditUrl = "https://github.com/" + organisationDirectory + "/documentation/edit/master/";
            proseEditUrl = "http://prose.io/#" + organisationDirectory + "/documentation/edit/master/";
            editUrl = githubEditUrl + a.relativePath.replace('learn/bevry/', '');
            if (organisation === 'docpad') {
              absoluteLink = "http://docpad.org/docs/" + name;
              document.set({
                render: false,
                write: false
              });
              if (category === 'partners') {
                document.set({
                  ignored: true
                });
              }
            }
            return document.setMetaDefaults({
              layout: layout,
              standalone: standalone,
              name: name,
              title: title,
              pageTitle: pageTitle,
              absoluteLink: absoluteLink,
              longLink: longLink,
              shortLink: shortLink,
              url: urls[0],
              editUrl: editUrl,
              organisationDirectory: organisationDirectory,
              organisation: organisation,
              organisationName: organisationName,
              projectDirectory: projectDirectory,
              project: project,
              projectName: projectName,
              categoryDirectory: categoryDirectory,
              category: category,
              categoryName: categoryName
            }).addUrl(urls);
          } else {
            console.log("The document " + a.relativePath + " was at an invalid path, so has been ignored");
            return document.setMetaDefaults({
              ignore: true,
              render: false,
              write: false
            });
          }
        });
      },
      pages: function(database) {
        return database.findAllLive({
          relativeOutDirPath: {
            $startsWith: 'pages'
          }
        }, [
          {
            filename: 1
          }
        ]);
      }
    },
    plugins: {
      highlightjs: {
        aliases: {
          stylus: 'css'
        }
      },
      repocloner: {
        repos: [
          {
            name: 'Bevry Documentation',
            path: 'src/documents/learn/bevry',
            url: 'https://github.com/bevry/documentation.git'
          }, {
            name: 'DocPad Documentation',
            path: 'src/documents/learn/docpad/docpad',
            url: 'https://github.com/docpad/documentation.git'
          }
        ]
      }
    },
    environments: {
      development: {
        templateData: {
          site: {
            services: {
              gauges: false,
              googleAnalytics: false,
              mixpanel: false,
              reinvigorate: false
            }
          }
        }
      }
    },
    events: {
      generateBefore: function(opts) {
        contributors = null;
        return true;
      },
      renderBefore: function(opts, next) {
        var docpad, users;
        docpad = this.docpad;
        if (contributors) {
          return next();
        }
        docpad.log('info', 'Fetching your latest contributors for display within the website');
        if (contributorsGetter == null) {
          contributorsGetter = require('getcontributors').create({
            github_client_id: process.env.BEVRY_GITHUB_CLIENT_ID,
            github_client_secret: process.env.BEVRY_GITHUB_CLIENT_SECRET
          });
        }
        users = ['bevry', 'docpad', 'webwrite', 'browserstate'];
        contributorsGetter.fetchContributorsFromUsers(users, function(err, _contributors) {
          if (_contributors == null) {
            _contributors = [];
          }
          if (err) {
            return next(err);
          }
          contributors = _contributors;
          docpad.log('info', "Fetched your latest contributors for display within the website, all " + _contributors.length + " of them");
          return next();
        });
        return true;
      },
      serverExtend: function(opts) {
        var codeBadRequest, codeRedirectPermanent, codeRedirectTemporary, codeSuccess, docpad, express, request, server;
        server = opts.server, express = opts.express;
        docpad = this.docpad;
        request = require('request');
        codeSuccess = 200;
        codeBadRequest = 400;
        codeRedirectPermanent = 301;
        codeRedirectTemporary = 302;
        server.all('/pushover', function(req, res) {
          if (__indexOf.call(docpad.getEnvironments(), 'development') >= 0) {
            return res.send(200);
          }
          return request({
            url: "https://api.pushover.net/1/messages.json",
            method: "POST",
            form: extendr.extend({
              token: process.env.BEVRY_PUSHOVER_TOKEN,
              user: process.env.BEVRY_PUSHOVER_USER_KEY,
              message: req.query
            }, req.query)
          }, function(_req, _res, body) {
            return res.send(body);
          });
        });
        server.all('/regenerate', function(req, res) {
          var _ref;
          if (((_ref = req.query) != null ? _ref.key : void 0) === process.env.WEBHOOK_KEY) {
            docpad.log('info', 'Regenerating for documentation change');
            docpad.action('generate', {
              populate: true,
              reload: true
            });
            return res.send(codeSuccess, 'regenerated');
          } else {
            return res.send(codeBadRequest, 'key is incorrect');
          }
        });
        server.get(/^\/(?:learn\/docpad-)(.*)$/, function(req, res) {
          return res.redirect(codeRedirectPermanent, "http://docpad.org/docs/" + (req.params[0] || ''));
        });
        server.get(/^\/(?:g|gh|github)(?:\/(.*))?$/, function(req, res) {
          return res.redirect(codeRedirectPermanent, "https://github.com/bevry/" + (req.params[0] || ''));
        });
        server.get(/^\/(?:t|twitter|tweet)(?:\/(.*))?$/, function(req, res) {
          return res.redirect(301, "https://twitter.com/bevryme");
        });
        server.get(/^\/(?:f|facebook)(?:\/(.*))?$/, function(req, res) {
          return res.redirect(301, "https://www.facebook.com/bevryme");
        });
        server.all('/payment', function(req, res) {
          if (pin == null) {
            pin = require('pinjs').setup({
              key: process.env.BEVRY_PIN_API_KEY_PRIVATE,
              production: isProduction
            });
          }
          req.body.amount *= 100;
          req.body.amount += 30;
          req.body.amount *= 1.04;
          return pin.createCharge(req.body, function(pinResponse) {
            console.log(pinResponse.body);
            return res.send(pinResponse.statusCode, pinResponse.body);
          });
        });
      }
    }
  };

  module.exports = docpadConfig;

}).call(this);
