Source: https://books.lesscrime.info/learncrimemapping/2026/setup.html

<a id="quarto-document-content"></a>
<a id="title-block-header"></a>
<a id="install-the-software-needed-for-this-book"></a>

# Install the software needed for this book

Figure: Students prepare software on a computer showing an installation arrow and progress bar.

Before we start mapping, we need to install the software we will need to make crime maps and reports.

<a id="step-1-install-r"></a>

## Step 1: install R

The first step is to download and install R, a programming language designed for analysing and visualising data, including making maps. To install R, follow the instructions below for whatever type of computer you are using. If you already have R installed on your computer, please update it to the latest release.

- `<a id="tabset-1-1-tab"></a>`{=html}[Windows]()
- `<a id="tabset-1-2-tab"></a>`{=html}[macOS]()
- `<a id="tabset-1-3-tab"></a>`{=html}[Ubuntu Linux]()

<a id="tabset-1-1"></a>

1.  Open your web browser and go to <https://cran.r-project.org/bin/windows/base/>.
2.  Click **Download R x.x.x for Windows**, where *x.x.x* is the latest version number.
3.  Wait for the installer to download.
4.  Open your **Downloads** folder.
5.  Double-click the downloaded `.exe` file. If Windows asks whether you want to allow the installer to make changes to your computer, click **Yes**.
6.  Select your preferred language if prompted.
7.  Click **OK**.
8.  Click **Next**.
9.  Leave all the default settings unchanged.
10. Continue clicking **Next** until you reach the **Install** button.
11. Click **Install**.
12. Wait for the installation to complete.
13. Click **Finish**.

<a id="tabset-1-2"></a>

The latest version of R requires macOS 14 or later on a Mac with an Apple Silicon processor, or macOS 11 or later on a Mac with an Intel processor.

1.  Open your web browser and go to <https://cran.r-project.org/bin/macosx/>.
2.  Download the installer appropriate for your Mac:
    - **Apple Silicon (`arm64`)** for Macs with an M1 or newer processor.
    - **Intel (`x86_64`)** for older Intel-based Macs.
3.  Wait for the installer to download.
4.  Open your **Downloads** folder.
5.  Double-click the downloaded `.pkg` file.
6.  If macOS asks whether you want to open the installer, click **Open**.
7.  Click **Continue**. Continue through the installation screens, accepting the licence agreement when prompted. Leave the installation location unchanged.
8.  Click **Install**.
9.  Enter your Mac password or use Touch ID if prompted.
10. Wait for the installation to complete.
11. Click **Close**.

<a id="tabset-1-3"></a>

These instructions work with currently supported long-term support (LTS) versions of Ubuntu: Ubuntu 22.04, 24.04 and 26.04.

1.  Open the **Terminal** application.

2.  Update the package list by typing:

    ``` {.sourceCode .numberSource .bash .number-lines .code-with-copy}
    sudo apt update -qq
    ```

3.  Press **Enter**.

4.  Install the software needed to add the official CRAN repository by typing:

    ``` {.sourceCode .numberSource .bash .number-lines .code-with-copy}
    sudo apt install --no-install-recommends software-properties-common dirmngr
    ```

5.  Press **Enter**. If Ubuntu asks whether you want to continue, type `Y` and press **Enter**.

6.  Add the security key used to verify software downloaded from CRAN by typing:

    ``` {.sourceCode .numberSource .bash .number-lines .code-with-copy}
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    ```

7.  Press **Enter**.

8.  Add the official CRAN repository for your version of Ubuntu by typing:

    ``` {.sourceCode .numberSource .bash .number-lines .code-with-copy}
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
    ```

9.  Press **Enter** and follow any instructions shown in the Terminal.

10. Install R by typing:

    ``` {.sourceCode .numberSource .bash .number-lines .code-with-copy}
    sudo apt install --no-install-recommends r-base
    ```

11. Press **Enter**. If Ubuntu asks whether you want to continue, type `Y` and press **Enter**.

12. Wait for Ubuntu to download and install R.

Important

Figure: R application icon: a blue letter R inside a grey oval, used to identify the application in the installation check.

When you install R, the installation wizard will also install a small piece of software called the R GUI (graphical user interface), which uses the R icon shown here. However, the R GUI is quite limited and so we will not be using it (very few people do). Instead, we will use Positron, a more powerful and user-friendly interface for R. To avoid inadvertently using the wrong software, **do not open the R GUI software**.

<a id="step-2-install-positron"></a>

## Step 2: install Positron

The next step is to install Positron, an app that you can use to work with the R programming language more efficiently. To install Positron, follow the instructions below for whatever type of computer you are using. If you already have Positron installed on your machine, please update it to the latest release.

- `<a id="tabset-2-1-tab"></a>`{=html}[Windows]()
- `<a id="tabset-2-2-tab"></a>`{=html}[macOS]()
- `<a id="tabset-2-3-tab"></a>`{=html}[Ubuntu Linux]()

<a id="tabset-2-1"></a>

Positron requires Windows 10 or later on most PCs, or Windows 11 on a PC with an ARM64 processor. Before installing Positron, make sure you have installed the [latest Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist).

1.  Open your web browser and go to <https://positron.posit.co/download/>.
2.  If you are asked to accept the Positron licence agreement and privacy policy, select the checkbox to confirm that you agree.
3.  Choose the installer appropriate for your computer:
    - Choose **Windows x64** unless you know that your computer has an ARM64 processor.
    - Choose **Windows ARM64** if your computer has an ARM64 processor.
4.  Choose the **User install** option. This installs Positron only for your Windows account and usually does not require administrator access.
5.  Wait for the installer to download.
6.  Open your **Downloads** folder.
7.  Double-click the downloaded `.exe` file.
8.  Follow the instructions shown by the installer. Leave the default installation options unchanged.
9.  Wait for the installation to complete.
10. Open the **Start** menu.
11. Search for **Positron**.
12. Click **Positron** to open it.
13. If Positron asks you to choose between R and Python, choose **R**.
14. If Positron asks you to select an R installation, choose the latest version of R shown in the list.

<a id="tabset-2-2"></a>

Positron requires macOS 11 or later.

1.  Open your web browser and go to <https://positron.posit.co/download/>.
2.  Download the installer appropriate for your Mac:
    - **macOS Apple Silicon** for Macs with an M1 or newer processor.
    - **macOS Intel** for older Intel-based Macs.
3.  If you are asked to accept the Positron licence agreement and privacy policy, select the checkbox to confirm that you agree.
4.  Click the download button.
5.  Wait for the installer to download.
6.  Open your **Downloads** folder.
7.  Double-click the downloaded `.dmg` file. A window containing the Positron icon will open. **Do not double-click the Positron icon**.
8.  Drag the **Positron** icon onto the **Applications** folder shown in the window.
9.  Wait for Positron to be copied into the Applications folder.
10. Close the installer window.
11. Open the **Applications** folder.
12. Double-click **Positron**.
13. If macOS asks whether you are sure you want to open Positron, click **Open**.
14. If Positron asks you to choose between R and Python, choose **R**.
15. If Positron asks you to select an R installation, choose the latest version of R shown in the list.

<a id="tabset-2-3"></a>

Positron requires Ubuntu 20.04 or later.

1.  Open your web browser and go to <https://positron.posit.co/download/>.
2.  Click **Download for Linux**.
3.  If you are asked to accept the Positron licence agreement and privacy policy, select the checkbox to confirm that you agree.
4.  Download the Debian or Ubuntu installer, which has a filename ending in `.deb`.
5.  Wait for the installer to download.
6.  Open your **Downloads** folder.
7.  Double-click the downloaded `.deb` file.
8.  When the software-installation window opens, click **Install**.
9.  Enter your password if prompted.
10. Wait for the installation to complete.
11. Open the applications menu.
12. Search for **Positron**.
13. Click **Positron** to open it.
14. If Positron asks you to choose between R and Python, choose **R**.
15. If Positron asks you to select an R installation, choose the latest version of R shown in the list.

<a id="step-3-install-rtools-windows-only"></a>

## Step 3: install Rtools (Windows only)

If you are using a Windows computer you should install Rtools. Rtools provides additional software that R uses when installing some packages. You only need to install Rtools if you are using Windows. Mac and Linux users already have the equivalent tools available through their operating system.

To install RTools:

1.  Open your web browser and go to <https://cran.r-project.org/bin/windows/Rtools/>.
2.  Click the link for the latest version of **Rtools** that matches your version of R.
3.  Wait for the installer to download.
4.  Open your **Downloads** folder.
5.  Double-click the downloaded `.exe` file.
6.  If Windows asks whether you want to allow the installer to make changes to your computer, click **Yes**.
7.  Click **Next**.
8.  Leave the default installation options unchanged.
9.  Continue clicking **Next** until you reach the **Install** button.
10. Click **Install**.
11. Wait for the installation to complete.
12. Click **Finish**.

<a id="set-up-r-for-crime-mapping"></a>

## Set up R for crime mapping

As we will learn in subsequent chapters, most of the mapping capabilities in R are provided by add-on packages. To download and install the packages you will need to run the code included in this book:

1.  Open Positron.
2.  Find the panel (usually in the bottom-left) marked **Console**.
3.  Find the `>` symbol at the bottom of that panel.
4.  Copy and paste [Code 1](#lst-setup-install-book-packages) to the right of the `>` symbol -- you can use the copy icon on the top-right of this code block to copy it to your clipboard:

<a id="lst-setup-install-book-packages"></a>

<figure>
<pre><code>R Console</code></pre>
<div class="sourceCode" id="cb2"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1" aria-hidden="true" tabindex="-1"></a><span class="cf">if</span> (<span class="sc">!</span><span class="fu">requireNamespace</span>(<span class="st">&quot;remotes&quot;</span>)) {</span>
<span id="cb2-2"><a href="#cb2-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">install.packages</span>(<span class="st">&quot;remotes&quot;</span>)</span>
<span id="cb2-3"><a href="#cb2-3" aria-hidden="true" tabindex="-1"></a>}</span>
<span id="cb2-4"><a href="#cb2-4" aria-hidden="true" tabindex="-1"></a>remotes<span class="sc">::</span><span class="fu">install_github</span>(<span class="st">&quot;mpjashby/learncrimemapping&quot;</span>)</span></code></pre></div>
<figcaption>Code 1</figcaption>
</figure>

5.  Press ReturnReturn on your keyboard.

Figure: Positron Console showing R startup messages followed by commands to install remotes and then the learncrimemapping package from GitHub. A greater-than prompt precedes the first command and a plus prompt precedes the second, showing that R is continuing the same expression. The commands to enter are provided in the text above.

Tip`Do you want to install from sources the package which needs compilation?` -- what should I do?

<a id="callout-2"></a>

If you see a popup message appear asking `Do you want to install from sources the package which needs compilation?`, you can safely choose 'No'.

Important

It will take a few minutes for the set-up process to finish. Once the process is complete, you will see the `>` symbol has appeared in the R Console again.
