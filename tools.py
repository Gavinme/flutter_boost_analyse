#!/usr/bin/env python3
# coding:utf-8
# author Gavinme
import json
import sys, os
# 根据APP来进行配置
PACKAGE = "com.xiwang.zaixian"

DEFAULT_MODULE = "app"

# email
GQ="ganq2@ke.com"
SYJ="shiyanjun001@ke.com"
HJ="hejian010@ke.com"
CS="chenshao001@ke.com"
GX="chenshao001@ke.com"
FB="fubiao001@ke.com"
LJZ="liangjinzhu001@ke.com"
XKY="xiekongying001@ke.com"
YHL="yanghonglin001@ke.com"
ZHB="zhanghebin002@ke.com"

def command(cmd):
    print (cmd)
    os.system(cmd)

# ----------- 帮助说明 -----------
def help():
    print ("帮助说明文档:")
    print ("./tools.py b                        构建插件 ./gradlew clean assembleDebug")
    print ("./tools.py c                        规范化的提交 git commit")
    print ("./tools.py d                        进入等待调试模式")
    print ("./tools.py e                        退出等待调试模式")
    print ("./tools.py p {t=topic} {reviewer}   push本地代码到gerrit,例子1:./tools.py p t=customer gq syj 例子2:./tools.py p all")
    print ("./tools.py t                        打印栈顶Activity")
    print ("./tools.py clear                    清理app缓存")
    print ("./tools.py task                     打印task栈")
    print ("./tools.py details                  打开app设置页面")
    print ("./tools.py clean_git                清理git仓库")
    print ("./tools.py profile                  打印编译时间profile")
    print ("./tools.py mem                      打印进程内存信息")
    print ("./tools.py adj                      打印进程相关信息（进程id、oom_adj值）")
    print ("./tools.py window {lines}           查看窗口层级,参数为显示的行数，不输入则为单行")
    print ("./tools.py depend {module name}     打印module依赖关系,参数为module名，不输入则为主模块")
    print ("./tools.py refresh_dep              更新gradle依赖的缓存，重新下载项目依赖")
    print ("./tools.py search {content}         全局搜索内容")
    print ("./tools.py code_lines               统计代码的总行数")
    print ("./tools.py init                     初始化组件工程")
    print ("./tools.py up                       切换组件分支")
    print ("./tools.py reset                    git reset远端的分支")
    print ("./tools.py dp                       输出 dependencies")
    print ("./tools.py git                      git.py")
    print ("注意：gradlew 相关指令依赖 java1.8 及以上，如有出错请检查是否版本正确或者 JavaHome 环境变量未配置")


# ----------- 工具类方法实现 -----------
# 打印栈顶Activity
def top():
    command("adb shell dumpsys activity top | grep  --color=always ACTIVITY")
    # adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp' --color=always


# push本地代码到gerrit的对应分支
def push_gerrit(*args):
    if len(args) == 0 or len(args[0]) == 0:
        other_params = "%"
        other_params += get_email("ALL")
    else:
        other_params = "%"
        i = 0
        for arg in args[0]:
            i += 1
            if i > 1:
                other_params += ","
            if "=" in arg:
                other_params += "topic=%s" % arg[2:]
            else:
                other_params += get_email(arg)
    push_str = "git push origin HEAD:refs/for/%s%s" % (get_origin_branch(), other_params)
    print (push_str)
    command(push_str)


def get_origin_branch():
    get_branch_command = "git branch -vv | grep '* ' | awk '{print $4}'"
    p = os.popen(get_branch_command)
    branch_name = p.readline().strip()
    end = len(branch_name) - 1
    start = branch_name.index('origin/') + 7
    origin_branch = branch_name[start:end]
    return origin_branch


def get_email(arg):
    if arg == "gq" or arg == "GQ":
        return "r=%s" % GQ
    elif arg == "syj" or arg == "SYJ":
        return "r=%s" % SYJ
    elif arg == "hj" or arg == "HJ":
        return "r=%s" % HJ
    elif arg == "cs" or arg == "CS":
        return "r=%s" % CS
    elif arg == "all" or arg == "ALL":
        return "r=%s,r=%s,r=%s,r=%s,r=%s,r=%s" % (GQ, SYJ, HJ,XKY,CS,GX)
    else:
        return ""


# 规范化的提交git commit
def commit():
    print ("请按照如下规范提交git的commit信息")
    reload(sys)
    sys.setdefaultencoding('utf-8')
    type = sys.getdefaultencoding()
    line1 = raw_input("请输入简要说明:\n")
    line2 = raw_input("请输入问题原因:\n")
    msg = "【%s】:\n%s\n\n【原因】:\n%s\n\n" % (
        get_origin_branch(), line1, line2)
    c_str = "git commit -m '%s'" % msg
    command(c_str)


# 进入等待调试模式
def debug():
    command("adb shell am set-debug-app -w %s" % PACKAGE)

# 清除等待调试模式
def clearDebug():
    command("adb shell am clear-debug-app -w %s" % PACKAGE)

# 清理app缓存
def clear():
    command("adb shell pm clear %s" % PACKAGE)



# 打开app设置页面
def details():
    command(
        "adb shell am start -a android.settings.APPLICATION_DETAILS_SETTINGS -d package:%s" % PACKAGE)


# 打印Task栈
def task():
    command(
        "adb shell dumpsys activity activities | grep --color=always ActivityRecord | grep  --color=always Hist")


# 清理git仓库
def clean_git():
    command("git reset HEAD . && git clean -fd && git checkout -- . && git status")


# 打印编译时间profile
def profile():
    command("./gradlew assembleDebug --offline --profile")


# 打印进程内存信息
def mem():
    command("adb shell dumpsys meminfo %s" % PACKAGE)


# 打印进程相关信息（进程id、oom_adj值）
def adj():
    command_str = "adb shell ps | grep %s | grep -v : | awk '{print $2}'" % PACKAGE
    p = os.popen(command_str)
    pid = p.readline().strip()
    print ("process id:%s" % pid)
    command("adb root")
    print ("process oom_adj:")
    command("adb shell cat /proc/%s/oom_adj" % pid)


# 查看窗口层级
def window(*args):
    if len(args) == 0:
        arg = 0
    else:
        arg = args[0][0]
    command("adb shell dumpsys window windows | grep 'Window #' --color -A %s" % arg)


# 打印module依赖关系
def depend(*args):
    if len(args) == 0:
        arg = DEFAULT_MODULE
    else:
        arg = args[0][0]
    command("./gradlew -q %s:dependencies>dependencies.log" % arg)


# 更新gradle依赖的缓存，重新下载项目依赖
def refresh_dep():
    command("./gradlew build --refresh-dependencies")


# 统计代码的总行数
def code_lines():
    command("find . -name \"*.java\"|xargs cat|grep -v ^$|wc -l")

# git reset远端的分支
def reset():
    resetInner()
    command("./resetVersionLocal.py")

def git():
    command("./git.py")

def resetInner():
    reset_str = "git reset --soft origin/%s" % (get_origin_branch())
    command(reset_str)

# 全局搜索内容
def search(*args):
    if len(args) == 0:
        return
    else:
        arg = args[0][0]
    command(
        "grep -E %s --exclude-dir={.git,lib,.gradle,.idea,build,captures} --exclude={*.jar}  . -R --color=always -n" % arg)

# 构建插件
def build():
    command("./gradlew clean assemblePre")

# 工程初始化
def init():
   commitMessage = input("将删除当前全部模块文件并根据配置全部拉取，我已经备份好了未提交代码 : (y/n) :")
   if(commitMessage != "y"):
        return
   command("python3 initVersionLocal.py")

# 更新本地的分支，请确保远程有分支
def up():
    command("python3 upVersionLocal.py")

def dependencies():
    command("./gradlew app:dependencies>dependencies.log")

# ----------- 方法缩写 -----------
def t():
    top()


def p(*args):
    push_gerrit(*args)


def d():
    debug()


def c():
    commit()

def e():
    clearDebug()

def i():
    install()
def b():
    build()

def dp():
    dependencies()


def changeProperties(*args):
    path=args[0][0]
    key=args[0][1]
    value=args[0][2]
    with open(path, 'r', encoding='utf-8') as f:
        lines = []  # 创建了一个空列表，里面没有元素
        for line in f.readlines():
            if line != '\n':
                lines.append(line)
        f.close()
    with open(path, 'w', encoding='utf-8') as f:
        flag=0
        for line in lines:
            if key in line:
                newline="{0}={1}".format(key, value)
                line = newline
                f.write('%s\n' % line)
                flag=1
            else:
                f.write('%s' % line)
        #####如果结尾没有仍然写入数据
        if (flag == 0):
            newline = "{0}={1}".format(key, value)
            line = newline
            f.write('%s\n' % line)
            flag = 1
        f.close()


def modules():
    f = open("componentVersion.json", encoding="utf-8")
    file = json.load(f)
    xw = file["XW"]

#     获取 CI 主工程上一级目录 TODO

    for gitRep in xw:
#         commandStr = "rm -rf ../%s && git clone -b %s --depth 1 git@codeup.aliyun.com:61e54b0e0bb300d827e1ae27/client/Android/%s.git  ../%s" %(gitRep["module_name"],gitRep["module_branch"] , gitRep["module_name"],gitRep["module_name"])
        print(gitRep["module_name"]+".source=false" )


def main():
    args = None
    if len(sys.argv) > 2:
        action = sys.argv[1]
        args = sys.argv[2:]
    elif len(sys.argv) > 1:
        action = sys.argv[1]
    else:
        action = "help"
    if args is None:
        call = "%s()" % action
    else:
        call = "%s(%s)" % (action, args)
    exec (call)


if __name__ == "__main__":
    main()
