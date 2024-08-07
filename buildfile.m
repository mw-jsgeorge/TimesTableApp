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

% plan("deploy").Dependencies = ["check" "test"];

% Make the "test" task the default task in the plan
plan.DefaultTasks = "check";

end

function deployTask(~)
% Deploy standalone application
compiler.build.standaloneApplication('source/timestable.mlapp');
end
