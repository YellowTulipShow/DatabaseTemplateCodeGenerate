# 代码生成程序相关

## 使用文档

拉取项目脚本, 更改至独有的Git仓库下, 直接调用 `./shell/` 下命令文件即可, 依据自身需要更改 `.gitignore` 的配置

### 使用前说明

首先拉取数据库下表结构: 使用命令行工具[YellowTulipShow/DatabaseStructurePullTool](https://github.com/YellowTulipShow/DatabaseStructurePullTool)

然后将数据库内容按照模版文件生成对应代码: 使用命令行工具[YellowTulipShow/NetTemplate](https://github.com/YellowTulipShow/NetTemplate)

### 调用脚本

使用 `powershell` 执行以下命令

安装执行脚本
```powershell
.\shell\install.ps1
```

拉取指定数据库的数据: 输入数据库前方的数字标识, 可输入多个, 使用英文逗号分隔
```powershell
.\shell\pull_db.ps1
```

生成模版文件: 依据拉取到的数据结构生成文件, 同样需要输入数字标识
```powershell
.\shell\generate.ps1
```

执行过程中会自动弹出生成目标的所在文件夹

### 模板说明

根目录 `./_template` 下 `.liquid` 结尾文件为模板
```C#
// AdminWeb.页面文件
_Basic_.html.liquid

// AdminWeb.页面文件随行的Ts
// Api.ts 需要添加的内容在其顶部需要单独拷贝
_Basic_.ts.liquid

// AdminWeb.页面编辑文件
_Basic_Edit.html.liquid

// AdminWebApi.后台接口文件
_Basic_Controller.cs.liquid
```

```C#
// Logic.通用库查询参数相关扩展文件
_Basic_Extend.cs.liquid

// Logic.自定义的编辑文件
_Basic__CRUD.cs.liquid
```

```C#
// AdminWeb.页面编辑用于 Easyui.Combogrid 控件的模板提供, 单选多选皆有
Extend/_Basic_Combogrid.html.liquid

// AdminWebApi.接口导出相关的文件
Extend/_Basic_Export.ts.liquid
Extend/_Basic_ExportController.cs.liquid

// AdminWeb.展示详情相关的功能页面
Extend/_Basic_InfoShowVue.html.liquid
Extend/_Basic_InfoShowVue.ts.liquid

// 以下可以忽略
Extend/_Basic_ExtendOld.cs.liquid

Extend/_Basic_TestDataGet.cs.liquid
```

### 添加新的数据库

读取项目说明文档即可: [YellowTulipShow/DatabaseStructurePullTool](https://github.com/YellowTulipShow/DatabaseStructurePullTool)

## 学习链接

* [.NET Core/.NET5/.NET6 开源项目汇总13：模板引擎](https://www.cnblogs.com/SavionZhang/p/15134445.html)
* [liquid 模板引擎语法中文文档](https://www.coderbusy.com/liquid/)
* [.net Fluid 基于 liquid 实现的模板引擎](https://www.nuget.org/packages/Fluid.Core)
* [Liquid基础语法](https://www.cnblogs.com/lslvxy/p/3651936.html)
* [Liquid 官方参考文档](https://www.w3cschool.cn/doc_liquid/)
