var express = require('express'),
  router = express.Router(),
  resources = require('./../resources/model');

router.route('/').get(function (req, res, next) {
  req.result = resources.pi.instructions;
  next();
});

router.route('/sample').post(function (req, res, next) {
   const { execFile } = require('child_process');

  execFile('/home/pi/API/processNodejsImage.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`error: ${error.message}`);
      return;
    }

    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }

   console.log(`stdout:\n${stdout}`);
  });

  next();
});


router.route('/train').put(function (req, res, next) {
   const { execFile } = require('child_process');

  execFile('/home/pi/API/processNodejsImage.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`error: ${error.message}`);
      return;
    }

    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }

   console.log(`stdout:\n${stdout}`);
  });

  next();
});

router.route('/streamsample').put(function (req, res, next) {
   const { execFile } = require('child_process');

  execFile('/home/pi/API/processNodejsImage.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`error: ${error.message}`);
      return;
    }

    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }

   console.log(`stdout:\n${stdout}`);
  });

  next();
});

router.route('/frequency').put(function (req, res, next) {
   const { execFile } = require('child_process');

  execFile('/home/pi/API/processNodejsImage.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`error: ${error.message}`);
      return;
    }

    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }

   console.log(`stdout:\n${stdout}`);
  });

  next();
});

module.exports = router;
