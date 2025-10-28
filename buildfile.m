function plan = buildfile

import matlab.buildtool.Task
import matlab.buildtool.tasks.CodeIssuesTask
import matlab.buildtool.tasks.PcodeTask


% Add the source folder to the path
addpath("source");

% Create a plan
plan = buildplan(localfunctions);

% Add a task to run tests
plan("test") = matlab.buildtool.tasks.TestTask("tests");

plan("check") = CodeIssuesTask;

plan("pcode") = PcodeTask("source","source");

plan("coverage") = Task( ...
    Description = "Generate decision coverage report", ...
    Actions = @decisionCoverageTask);

% plan("deploy").Dependencies = ["check" "test"];

% Make the "test" task the default task in the plan
plan.DefaultTasks = "check";

end

function deployTask(~)
% Deploy standalone application
compiler.build.standaloneApplication('source/timestable.mlapp');
end

function decisionCoverageTask(~)
    import matlab.unittest.TestSuite
    import matlab.unittest.plugins.CodeCoveragePlugin
    import matlab.unittest.plugins.codecoverage.CoverageReport
    import matlab.unittest.plugins.codecoverage.CoverageMetrics
    suite = TestSuite.fromFolder("tests", "IncludingSubfolders", true);
    runner = matlab.unittest.TestRunner.withTextOutput;

    plugin = CodeCoveragePlugin.forFolder("source", ...
        "IncludingSubfolders", true, ...
        "Producing", CoverageReport("coverage-report", ...
            "Metric", CoverageMetrics.Decision));

    runner.addPlugin(plugin);
    runner.run(suite);
end
