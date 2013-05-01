# coding=utf-8

###### Options ######

options={}

options["<config>"]=ur'Default'
options["<os>"]=ur'iphone'
options["appdata"]=ur'/Users/Sam/.config/marmalade/DeployTool'
options["build"]=ur'ARM GCC Debug'
options["cmdline"]=['/Developer/Marmalade/6.2/s3e/makefile_builder/mkb.py', '/Users/Sam/Documents/Quick/Projects/Blockenspiel/Blockenspiel.mkb_temp', '--non-interactive', '--no-make', '--no-ide', '--buildenv=WEB', '--builddir', 'build_temp', '--use-prebuilt', '--deploy-only']
options["configlist"]=ur'Default ,'
options["deploymode"]=ur'Package'
options["device"]=ur'"{"localdir}/Deploy.py" device "{"tempdir}/DeployOpts.py" {hasmkb}'
options["dir"]=ur'/Users/Sam/Documents/Quick/Projects/Blockenspiel/build_temp'
options["folder"]=ur'"{"localdir}/Deploy.py" folder "{"tempdir}/DeployOpts.py" {hasmkb}'
options["hasmkb"]=ur'nomkb'
options["helpfile"]=ur'../docs/Deployment.chm'
options["helppage"]=ur'0'
options["mkb"]=ur''
options["outdir"]=ur'/Users/Sam/Documents/Quick/Projects/Blockenspiel/build_temp'
options["resdir"]=ur'/Developer/Marmalade/6.2/Applications/DeployTool.app/Contents/Resources/'
options["s3edir"]=ur'/Developer/Marmalade/6.2/s3e/'
options["stage"]=ur''
options["task"]=ur'Default'
options["tasktype"]=ur'Package'

###### Tasks ######

tasks=[]

### Task Default:iphone ###

t={}
tasks.append(t)
t["tasktype"]="Package"
t["<config>"]="Default"
t["os"]="iphone"
t["endDir"]="/Users/Sam/Documents/Quick/Projects/Blockenspiel/build_temp/deployments/default/iphone/debug"
t["loader"]=["Debug"]
