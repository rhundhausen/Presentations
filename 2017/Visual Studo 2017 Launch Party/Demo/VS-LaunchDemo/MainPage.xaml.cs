using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace VS_LaunchDemo
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        private bool _loggedIn;

        public MainPage()
        {
            this.InitializeComponent();
            List.ItemsSource = System.Linq.Enumerable.Range(1, 1000).Select(i => new Model { Value = i });
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            if(UserPanel == null)
            {
                FindName("UserPanel");
            }
            _loggedIn = !_loggedIn;
            if(_loggedIn)
            {
                UserPanel.Visibility = Visibility.Visible;
            }
            else
            {
                UserPanel.Visibility = Visibility.Collapsed;
            }
        }
    }
}
